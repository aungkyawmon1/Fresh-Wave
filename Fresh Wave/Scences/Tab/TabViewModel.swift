//
//  TabViewModel.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 19/4/2567 BE.
//

import Foundation
import RxRelay

class TabViewModel: BaseViewModel {
    private let orderModel: OrderModel
    private var _currentOrderVO: OrderVO?
    
    init(orderModel: OrderModel) {
        self.orderModel = orderModel
    }
    
    func fetchNearestAgent() {
        orderModel.getNearestAgent().subscribe(onNext: {[weak self] response in
            guard let _ = self else { return }
            Preference.saveNearestAgentInfo(response)
        }).disposed(by: disposableBag)
    }
    
    func fetchOrderStatus() {
        orderModel.getOrderStatus().subscribe(onNext: {[weak self] response in
            guard let self = self else { return }
            if let _ = response.id {
                Preference.saveCurrentOrderVO(response)
            } else {
                Preference.removeOrderVO()
            }
        }).disposed(by: disposableBag)
    }
    
    var orderVO: OrderVO? {
        get { _currentOrderVO }
    }
}
