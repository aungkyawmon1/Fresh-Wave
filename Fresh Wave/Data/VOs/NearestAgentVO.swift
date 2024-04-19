//
//  NearestAgentVO.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 19/4/2567 BE.
//

import Foundation

// MARK: - NearestAgentVO
struct NearestAgentVO: Codable {
    let id: Int?
    let username, latitude, longitude, address: String?
}
