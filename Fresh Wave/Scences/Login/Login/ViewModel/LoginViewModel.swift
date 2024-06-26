//
//  LoginViewModel.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 21/03/2024.
//

import Foundation
import RxRelay
import RxSwift

class LoginViewModel: BaseViewModel {
    private let authModel: AuthModel
    
    let phoneNumberResponse = BehaviorRelay<SuccessResponse?>(value: nil)
    let verifyProfileResponse = BehaviorRelay<Bool?>(value: nil)
    let phoneSubject = BehaviorSubject<String>(value: "")
    
    init(authModel: AuthModel) {
        self.authModel = authModel
    }
    
    func isValid() -> Observable<Bool> {
        return phoneSubject.asObservable().startWith("").map { $0.count > 8
        }.startWith(false)
    }
    
    func checkPhoneNumber(_ phoneNo: String) {
        let body: RequestBody = ["phone_no": phoneNo]
        self.loadingPublishRelay.accept(true)
        authModel.checkPhoneNo(body: body).subscribe(onNext: {[weak self] response in
            guard let self = self else { return }
            self.loadingPublishRelay.accept(false)
            self.phoneNumberResponse.accept(response)
        }, onError: { [weak self] error in
            guard let self = self else { return }
            self.loadingPublishRelay.accept(false)
            if let error = error as? ApiError {
                switch error {
                case .badRequest:
                    self.verifyProfileResponse.accept(true)
                default:
                    debugPrint("")
                }
            }
            self.errorObservable.accept(error)
        }).disposed(by: disposableBag)
        
    }
    
}
