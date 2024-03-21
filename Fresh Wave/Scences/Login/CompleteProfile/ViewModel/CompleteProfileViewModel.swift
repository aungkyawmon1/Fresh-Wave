//
//  CompleteProfileViewModel.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 21/03/2024.
//

import Foundation
import RxRelay
import RxSwift

class CompleteProfileViewModel: BaseViewModel {
    private let authModel: AuthModel
    
    private let phoneNo: String
    var userProfile = BehaviorRelay<SuccessResponse?>(value: nil)
    var nameSubject = BehaviorSubject<String>(value: "")
    var floorSubject = BehaviorSubject<String>(value: "")
    
    init(authModel: AuthModel, phoneNo: String) {
        self.authModel = authModel
        self.phoneNo = phoneNo
    }
    
    func registerCustomer(userName: String, address: String, latidute: String, longtidue: String) {
        let body: RequestBody = ["username": userName, "phone_no": phoneNo, "address": address, "latitude": latidute, "longitude": longtidue]
        loadingPublishRelay.accept(true)
        authModel.registerCustomer(body: body).subscribe(onNext: {[weak self] response in
            guard let self = self else { return }
            self.loadingPublishRelay.accept(false)
            self.userProfile.accept(response)
        }, onError: { [weak self] error in
            guard let self = self else { return }
            self.loadingPublishRelay.accept(false)
            self.errorObservable.accept(error)
        }).disposed(by: disposableBag)
    }
}
