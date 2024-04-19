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
    
    func getNearestAgent() -> Observable<NearestAgentVO>
    
    func placeOrder(body: RequestBody) -> Observable<SuccessResponse>
    
    func getOrderStatus() -> Observable<OrderVO>
}

class OrderModelImpl: BaseModel, OrderModel {
    static let shared = OrderModelImpl()
    
    func getOrderHistory() -> Observable<OrderHistoryVO> {
        service.request(endpoint: .customerOrderHistory, response: OrderHistoryVO.self)
    }
    
    func placeOrder(body: RequestBody) -> Observable<SuccessResponse> {
        service.request(endpoint: .placeOrder(body), response: SuccessResponse.self)
    }
    
    func getNearestAgent() -> Observable<NearestAgentVO> {
        service.request(endpoint: .nearestAgent, response: NearestAgentVO.self)
    }
    
    func getOrderStatus() -> Observable<OrderVO> {
        service.request(endpoint: .orderStatus, response: OrderVO.self)
    }
}
