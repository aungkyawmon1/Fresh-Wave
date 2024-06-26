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
    
    private var _latitude: String? = Preference.getUserInfo()?.latitude
    private var _longitude: String? = Preference.getUserInfo()?.longitude
    
    let updateProfileResponse = BehaviorRelay<UserVO?>(value: nil)
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
        let body: RequestBody = ["username": userName, "phone_no": Preference.getUserInfo()?.phoneNo ?? "", "address": address, "latitude": _latitude ?? "", "longitude": _longitude ?? ""]
        loadingPublishRelay.accept(true)
        authModel.updateProfile(body: body).subscribe(onNext: { [weak self] response in
            guard let self = self else { return }
            self.getProfile()
        }, onError: { [weak self] error in
            guard let self = self else { return }
            self.loadingPublishRelay.accept(false)
            self.errorObservable.accept(error)
        }).disposed(by: disposableBag)
        
    }
    
    func getProfile() {
        self.loadingPublishRelay.accept(true)
        authModel.getUserProfile().subscribe(onNext: {[weak self] userProfile in
            guard let self = self else { return }
            self.loadingPublishRelay.accept(false)
            Preference.saveUserInfo(userProfile)
            self.updateProfileResponse.accept(userProfile)
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
        return Preference.getUserInfo()?.username
    }
    
    var address: String? {
        return Preference.getUserInfo()?.address
    }
}
