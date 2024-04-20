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
    
    func updateProfile(body: RequestBody) -> Observable<SuccessResponse>
    
    func checkPhoneNo(body: RequestBody) -> Observable<SuccessResponse>
    
    func loginWithPhoneNumber(body: RequestBody) -> Observable<LoginResponse>
    
    func getUserProfile() -> Observable<UserVO>
}

class AuthModelImpl: BaseModel, AuthModel {
    
    static let shared = AuthModelImpl()
    
    private override init() {}
    
    func registerCustomer(body: RequestBody) -> Observable<SuccessResponse> {
        service.request(endpoint: .registerCustomer(body), response: SuccessResponse.self)
    }
    
    func updateProfile(body: RequestBody) -> Observable<SuccessResponse> {
        service.request(endpoint: .updateProfile(body), response: SuccessResponse.self)
    }
    
    func checkPhoneNo(body: RequestBody) -> Observable<SuccessResponse> {
        service.request(endpoint: .checkPhone(body), response: SuccessResponse.self)
    }
    
    func loginWithPhoneNumber(body: RequestBody) -> Observable<LoginResponse> {
        service.request(endpoint: .customerLogin(body), response: LoginResponse.self)
    }
    
    func getUserProfile() -> Observable<UserVO> {
        service.request(endpoint: .userProfile, response: UserVO.self)
    }
}
