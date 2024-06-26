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
    private var _latitude: String?
    private var _longitude: String?
    
    let userProfile = BehaviorRelay<SuccessResponse?>(value: nil)
    var nameSubject = PublishSubject<String?>()
    let addressSubject = PublishSubject<String?>()

    
    init(authModel: AuthModel, phoneNo: String) {
        self.authModel = authModel
        self.phoneNo = phoneNo
    }
    
    func areAllFieldsValid() -> Observable<Bool> {
        return Observable.combineLatest(nameSubject, addressSubject ) { name, address in
            // Ensure all fields are non-empty
            return !(name?.isEmpty ?? true) && !(address?.isEmpty ?? true)
        }
    }
    
    func registerCustomer(userName: String, address: String) {
        let body: RequestBody = ["username": userName, "phone_no": phoneNo, "address": address, "latitude": _latitude ?? "", "longitude": _longitude ?? ""]
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
    
    func setLocation(lat: Double, lon: Double) {
        _latitude = "\(lat)"
        _longitude = "\(lon)"
    }
}
