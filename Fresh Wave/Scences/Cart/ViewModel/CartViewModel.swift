//
//  CartViewModel.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 19/4/2567 BE.
//

import Foundation
import RxRelay



class CartViewModel: BaseViewModel {
    private let orderModel: OrderModel
    
    let orderSuccessRelay = BehaviorRelay<SuccessResponse?>(value: nil)
    let orderVORelay = BehaviorRelay<OrderVO?>(value: nil)
    
    private var _currentOrderNumber: Int = (KeychainService.shared.getOrderNumber() ?? "1").stringToInt()
    
    private var _currentFloorNumber: Int = (KeychainService.shared.getOrderNumber() ?? "0").stringToInt()
    
    private var _isNewUser: Bool = KeychainService.shared.getNewUser()
    
    private let basePrice: Int = 700
    private let baseFloorPrice: Int = 100
    private let baseBottleFee: Int = 3000
    
    init(orderModel: OrderModel) {
        self.orderModel = orderModel
    }
    
    func increaseOrderNumber() {
        _currentOrderNumber += 1
    }
    
    func decreaseOrderNumber() {
        _currentOrderNumber -= 1
    }
    
    func increaseFloorNumber() {
        _currentFloorNumber += 1
    }
    
    func decreaseFloorNumber() {
        _currentFloorNumber -= 1
    }
    
    func getUpdatedBasePrice() -> Int {
        _currentOrderNumber * basePrice
    }
    
    func getUpdatedFloorPrice() -> Int {
        _currentFloorNumber * baseFloorPrice
    }
    
    func getUpdatedBottleFee() -> Int {
        _currentOrderNumber * baseBottleFee
    }
    
    func getTotalPrice() -> Int {
        if isNewUser {
            return getUpdatedBasePrice() + getUpdatedFloorPrice() + getUpdatedBottleFee()
        } else {
            return getUpdatedBasePrice() + getUpdatedFloorPrice()
        }
    }
    
    var isNewUser: Bool {
        get { _isNewUser }
    }
    
    var currentOrderNumber: Int {
        get { _currentOrderNumber }
    }
    
    var currentFloorNumber: Int {
        get { _currentFloorNumber }
    }
    
    var userAddress: String? {
        get { Preference.getUserInfo()?.address }
    }
    
    var agentAddress: String? {
        get {
            Preference.getNearestAgentInfo()?.address
        }
    }
    
    var agentName: String? {
        get {
            Preference.getNearestAgentInfo()?.username
        }
    }
    
    func placeOrder() {
        let agentId = Preference.getNearestAgentInfo()?.id ?? 0
        let body: RequestBody = [
            "agent_id": agentId,
            "count": _currentOrderNumber,
            "price": "\(getUpdatedBasePrice())",
            "floor_price": "\(getUpdatedFloorPrice())",
            "net_price": _isNewUser ? "\(getUpdatedBottleFee())" : "0",
            "total_price": "\(getTotalPrice())"
        ]
        loadingPublishRelay.accept(true)
        orderModel.placeOrder(body: body).subscribe(onNext: {[weak self] response in
            guard let self = self else { return }
            self.fetchOrderStatusAfterOrdering()
            KeychainService.shared.setNewUser(false)
        }, onError: {[weak self] error in
            guard let self = self else { return }
            self.loadingPublishRelay.accept(false)
            self.errorObservable.accept(error)
        }).disposed(by: disposableBag)
    }
    
    func fetchOrderStatusAfterOrdering() {
        loadingPublishRelay.accept(true)
        orderModel.getOrderStatus().subscribe(onNext: {[weak self] response in
            guard let self = self else { return }
            self.loadingPublishRelay.accept(false)
            if let _ = response.id {
                Preference.saveCurrentOrderVO(response)
            } else {
                Preference.removeOrderVO()
            }
            self.orderSuccessRelay.accept(SuccessResponse(status: "Success", code: 200, message: "Order is successful."))
            
        }, onError: {[weak self] error in
            guard let self = self else { return }
            self.loadingPublishRelay.accept(false)
            self.errorObservable.accept(error)
        }).disposed(by: disposableBag)
    }
    
}
