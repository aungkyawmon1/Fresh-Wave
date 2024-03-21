//
//  AuthModel.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 21/03/2024.
//

import Foundation
import RxSwift

protocol AuthModel {
    
    func registerCustomer(body: RequestBody) -> Observable<SuccessResponse>
    
    func checkPhoneNo(body: RequestBody) -> Observable<SuccessResponse>
}

class AuthModelImpl: BaseModel, AuthModel {
    
    static let shared = AuthModelImpl()
    
    private override init() {}
    
    func registerCustomer(body: RequestBody) -> Observable<SuccessResponse> {
        service.request(endpoint: .registerCustomer(body), response: SuccessResponse.self)
    }
    
    func checkPhoneNo(body: RequestBody) -> Observable<SuccessResponse> {
        service.request(endpoint: .checkPhone(body), response: SuccessResponse.self)
    }
}
