//
//  BaseViewModel.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 19/02/2024.
//

import Foundation
import RxSwift
import RxRelay

class BaseViewModel {
    let disposableBag = DisposeBag()
    
    let loadingPublishRelay = PublishRelay<Bool>()
    let isNoInternetPublishRelay = PublishRelay<Bool?>()
    let errorPublishRelay = PublishRelay<String>()
    let errorObservable = BehaviorRelay<Error?>(value: nil)
    
    private var viewController : BaseViewController?
    
    func bindViewModel(in viewController: BaseViewController? = nil) {
        self.viewController = viewController
        
        loadingPublishRelay.bind {
            if $0 {
                viewController?.showLoading()
            } else {
                viewController?.hideLoading()
            }
        }.disposed(by: disposableBag)
        
        errorPublishRelay.bind {
            viewController?.showAlert(title: "Error", message: $0)
        }.disposed(by: disposableBag)
        
        errorObservable.subscribe(onNext: { (error) in
            
            viewController?.hideLoading()
            
            if let error = error as? ApiError {
                switch error {
                case .noConnection:
                    self.isNoInternetPublishRelay.accept(true)
                case .sessionExpired:
                    self.viewController?.doLogOut()
                    self.viewController?.showMessage("Session Expired!")
                case .unauthorized:
                    self.viewController?.showMessage("Unauthorized!")
                case .decodingError(_):
                    self.viewController?.showMessage("Decoding Error!")
                case .serverError(let code):
                    debugPrint(code)
                    self.viewController?.showMessage("Server Error!\(code)")
                case .requestTimeOut:
                    self.viewController?.showMessage("Request Time Out!")
                case .requestCancel:
                    self.viewController?.showMessage("Request Error!")
                case .validationError(_):
                    self.viewController?.showMessage("Validation Error!")
                    
                case .badRequest:
                    debugPrint("")
                }
            }
            
        }).disposed(by: disposableBag)
    }
}
