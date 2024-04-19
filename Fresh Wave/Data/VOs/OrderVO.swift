//
//  OrderVO.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 14/04/2024.
//

import Foundation

// MARK: - Welcome
struct OrderVO: Codable {
    let id, userID, agentID, status: Int?
    let count: Int?
    let price, floorPrice, netPrice, totalPrice: String?
    let createdDate, updatedDate, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case agentID = "agent_id"
        case status, count, price
        case floorPrice = "floor_price"
        case netPrice = "net_price"
        case totalPrice = "total_price"
        case createdDate = "created_date"
        case updatedDate = "updated_date"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    var orderStatus: String {
        let currentStatus = status ?? 0
        if currentStatus == 2 {
            return "Accepted"
        } else if currentStatus == 4 {
            return "Delivering"
        } else if currentStatus == 5 {
            return "Delivered"
        } else if currentStatus == 3 {
            return "Canceled"
        } else {
            return "Ordering"
        }
    }
}
