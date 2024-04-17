//
//  EditProfileViewModel.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 14/04/2024.
//

import Foundation
import RxRelay
import RxSwift

class EditProfileViewModel: BaseViewModel {
    
    private let authModel: AuthModel
    
    private var _latitude: String? = Preference.getAgentInfo()?.latitude
    private var _longitude: String? = Preference.getAgentInfo()?.longitude
    
    let updateProfileResponse = BehaviorRelay<SuccessResponse?>(value: nil)
    var nameSubject = PublishSubject<String?>()
    let addressSubject = PublishSubject<String?>()
    
    init(authModel: AuthModel) {
        self.authModel = authModel
    }
    
    func areAllFieldsValid() -> Observable<Bool> {
        return Observable.combineLatest(nameSubject, addressSubject ) { name, address in
            // Ensure all fields are non-empty
            return !(name?.isEmpty ?? true) && !(address?.isEmpty ?? true)
        }
    }
    
    func updateProfile(userName: String, address: String) {
        let body: RequestBody = ["username": userName, "phone_no": Preference.getAgentInfo()?.phoneNo ?? "", "address": address, "latitude": _latitude ?? "", "longitude": _longitude ?? ""]
        loadingPublishRelay.accept(true)
        authModel.updateProfile(body: body).subscribe(onNext: { [weak self] response in
            guard let self = self else { return }
            self.loadingPublishRelay.accept(false)
            self.updateProfileResponse.accept(response)
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
    
    var userName: String? {
        return Preference.getAgentInfo()?.username
    }
    
    var address: String? {
        return Preference.getAgentInfo()?.address
    }
}
