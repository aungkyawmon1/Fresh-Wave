//
//  OrderHistoryViewModel.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 26/03/2024.
//

import Foundation
import RxRelay

class OrderHistoryViewModel: BaseViewModel {
    private let orderModel: OrderModel
    
    let orderHistoryList = BehaviorRelay<[OrderVO]?>(value: nil)
    
    init(orderModel: OrderModel) {
        self.orderModel = orderModel
    }
    
    func getOrderHistory() {
        self.loadingPublishRelay.accept(false)
        orderModel.getOrderHistory().subscribe(onNext: {[weak self] response in
            guard let self = self else { return }
            self.loadingPublishRelay.accept(false)
            orderHistoryList.accept(response.data)
        }, onError: {[weak self] error in
            guard let self = self else { return }
            self.loadingPublishRelay.accept(false)
            self.errorObservable.accept(error)
        }).disposed(by: disposableBag)
    }
    
    func noOfOrder() -> Int {
        orderHistoryList.value?.count ?? 0
    }
    
    func getOrderVO(at index: Int) -> OrderVO? {
        orderHistoryList.value?[index]
    }
}
