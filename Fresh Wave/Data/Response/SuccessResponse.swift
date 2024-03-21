//
//  SuccessResponse.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 21/03/2024.
//

import Foundation

// MARK: - SuccessResponse
struct SuccessResponse: Codable {
    let status: String?
    let code: Int?
    let message: String?
}
