//
//  OrderModel.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 26/03/2024.
//

import Foundation
import RxSwift

protocol OrderModel {
    func getOrderHistory() -> Observable<OrderHistoryVO>
}

class OrderModelImpl: BaseModel, OrderModel {
    static let shared = OrderModelImpl()
    
    func getOrderHistory() -> Observable<OrderHistoryVO> {
        service.request(endpoint: .customerOrderHistory, response: OrderHistoryVO.self)
    }
}
