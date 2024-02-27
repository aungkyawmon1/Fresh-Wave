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
    }
}
