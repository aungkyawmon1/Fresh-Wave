//
//  VerifyViewModel.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 22/03/2024.
//

import Foundation
import RxRelay
import RxSwift
import FirebaseAuth

class VerifyViewModel: BaseViewModel {
    private let authModel: AuthModel
    private let phoneNumber: String
    
    let otpSubject = PublishSubject<String>()
    let loginResponse = BehaviorRelay<LoginResponse?>(value: nil)
    let otpCodeSuccess = BehaviorRelay<Bool?>(value: nil)
    let showOTPMessage = BehaviorRelay<String?>(value: nil)
    var phoneSubject = BehaviorSubject<String>(value: "")
    
    init(authModel: AuthModel, phoneNumber: String) {
        self.authModel = authModel
        self.phoneNumber = phoneNumber
    }
    
    func isValid() -> Observable<Bool> {
        otpSubject.asObservable().startWith("").map {
            $0.count == 6
        }.startWith(false)
    }
    
    func loginWithPhoneNumber() {
        let body: RequestBody = ["phone_no": phoneNumber]
        self.loadingPublishRelay.accept(true)
        authModel.loginWithPhoneNumber(body: body).subscribe(onNext: { [weak self] data in
            guard let self = self else { return }
            self.loadingPublishRelay.accept(false)
            self.manageTokenResponse(data)
            
            self.loginResponse.accept(data)
           
        },onError: { [weak self] error in
            guard let self = self else { return }
            self.loadingPublishRelay.accept(false)
            self.errorObservable.accept(error)
        }).disposed(by: disposableBag)
    }
    
    func requestOTPCode() {
        self.loadingPublishRelay.accept(true)
        //Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        PhoneAuthProvider.provider()
          .verifyPhoneNumber("+66\(phoneNumber)", uiDelegate: nil) { verificationID, error in
              self.loadingPublishRelay.accept(false)
              if let _ = error {
                  self.showOTPMessage.accept("OTP Code Error")
                return
              }
              Preference.setValue(verificationID, forKey: .authVerificationID)
              self.otpCodeSuccess.accept(true)
          }
    }
    
    func verifyOTPCode(verificationCode: String) {
       
        guard let verificationID = Preference.getString(forKey: .authVerificationID) else { return }
        let credential = PhoneAuthProvider.provider().credential(
          withVerificationID: verificationID,
          verificationCode: verificationCode
        )
        
        Auth.auth().signIn(with: credential) { authResult, error in
            if let _ = error {
                self.showOTPMessage.accept("Verification Error")
            }
            self.loginWithPhoneNumber()
        }
    }
    
    private func manageTokenResponse(_ response: LoginResponse) {
        KeychainService.shared.saveAccessToken(response.accessToken ?? "")
        debugPrint("Access token", response.accessToken ?? "")
        Preference.setValue(true, forKey: .isAuth)
        guard let agentVO = response.user else { return }
        Preference.saveAgentInfo(agentVO)
    }
    
}
