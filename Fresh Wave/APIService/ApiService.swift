//
//  ApiService.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 17/02/2024.
//

import Foundation
import Alamofire
import RxSwift

enum RequestResult<T: Decodable>{
    case success(T)
    case failure(ApiError)
}

/// Define network request configuration and hanle responses
class ApiService {
    
    /// Initialize ApiService with custom configurations
    static let shared = ApiService()
    
    private var session: Session
   // private let interceptor = Interceptor()
    
    private init() {
        let configuaration = URLSessionConfiguration.default
        configuaration.timeoutIntervalForRequest = 60
        configuaration.requestCachePolicy = .useProtocolCachePolicy
       
        session = Session(
            configuration: configuaration,
            requestQueue: .global()
        )
    }
    
    /// Use to fetch data from network service.
    ///
    /// Create a data request from provided endpoint and handle response. Response is handled based on status code wheter it is failure or success.
    ///
    /// - Parameters:
    ///   - endPoint: URL ``Endpoint``  to fetch network data.
    ///   - response: Response data type to decode.
    ///
    /// - Returns: Decoded data wrapped with Observable type.
    ///
    func request<T: Decodable> (endpoint: Endpoint, response: T.Type) -> Observable<T> {
        return Observable.create { observer in
            let dataRequest = self.createDataRequest(endpoint: endpoint)
            self.handleDataResponse(dataRequest: dataRequest, observer: observer)
            return Disposables.create {
                dataRequest.cancel()
            }
        }
    }
    
    /// Use to upload data to network service.
    ///
    /// Create an upload request from provided endpoint and handle response. Response is handled based on status code wheter it is failure or success.
    ///
    /// - Parameters:
    ///   - endPoint: URL ``Endpoint``  to fetch network data.
    ///   - response: Response data type to decode.
    ///
    /// - Returns: Decoded data wrapped with Observable type.
    ///
    func upload<T: Decodable> (endpoint: Endpoint, response: T.Type, formData: @escaping (MultipartFormData) -> Void) -> Observable<T> {
        return Observable.create { observer in
            let dataUpload = self.createDataUpload(endpoint: endpoint, formData: formData)
            self.handleDataResponse(dataRequest: dataUpload, observer: observer)
            return Disposables.create {
                dataUpload.cancel()
            }
        }
    }
    

    private func createDataRequest(endpoint: Endpoint) -> DataRequest {
        var newHeader = endpoint.headers
        if endpoint.attribute.authed {
            newHeader?.add(.authorization(bearerToken: KeychainService.shared.getAccessToken() ?? ""))
        }
        return session.request(
            endpoint.attribute.url,
            method: endpoint.attribute.method,
            parameters: endpoint.attribute.parameters,
            encoding: endpoint.attribute.encoding,
            headers: newHeader
        )
    }
    
    
    private func createDataUpload(endpoint: Endpoint, formData: @escaping (MultipartFormData) -> Void) -> UploadRequest {
        var newHeader = endpoint.headers
    
        if endpoint.attribute.authed {
            newHeader?.add(.authorization(bearerToken: KeychainService.shared.getAccessToken() ?? ""))
        }
        return session.upload(
            multipartFormData: formData,
            to: endpoint.attribute.url,
            method: endpoint.attribute.method,
            headers: newHeader
        )
    }

    
    private func handleDataResponse<T: Decodable>(dataRequest: DataRequest, observer: AnyObserver<T>) {
        dataRequest.responseData { responseData in
            let statusCode = responseData.response?.statusCode ?? 0
            if statusCode == 401 {
                observer.onError(ApiError.sessionExpired)
            } else if statusCode == 400 {
                observer.onError(ApiError.badRequest)
            }
            switch responseData.result {
            case .success(let data):
                self.handleSuccessResponse(data: data, statusCode: statusCode, observer: observer)
            case .failure(let error):
                self.handleFailureResponse(error: error, observer: observer)
            }
        }
    }

    private func handleSuccessResponse<T: Decodable>(data: Data, statusCode: Int, observer: AnyObserver<T>) {
        do {
            if 200...299 ~= statusCode {
                let resultData = try JSONDecoder().decode(T.self, from: data)
                observer.onNext(resultData)
                observer.onCompleted()
            } else {
                do {
                    let resultData = try JSONDecoder().decode(ErrorResponse.self, from: data)
                    observer.onError(ApiError.validationError(resultData))
                } catch {
                    observer.onError(ApiError.serverError(String(statusCode)))
                }
            }
        } catch {
            observer.onError(ApiError.decodingError(statusCode))
        }
    }

    private func handleFailureResponse<T: Decodable>(error: AFError, observer: AnyObserver<T>) {
        switch error {
        case .sessionTaskFailed(error: URLError.dataNotAllowed),
             .sessionTaskFailed(error: URLError.networkConnectionLost),
             .sessionTaskFailed(error: URLError.notConnectedToInternet):
            observer.onError(ApiError.noConnection)
        case .sessionTaskFailed(error: URLError.timedOut):
            observer.onError(ApiError.requestTimeOut)
        case .explicitlyCancelled:
            observer.onError(ApiError.requestCancel)
        default:
            observer.onError(ApiError.serverError(error.errorDescription ?? ""))
        }
    }
    
}
