//
//  OrderHistoryVO.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 26/03/2024.
//

import Foundation

// MARK: - Welcome
struct OrderHistoryVO: Codable {
    let data: [OrderVO]?
    let pagination: PaginationVO?
}
