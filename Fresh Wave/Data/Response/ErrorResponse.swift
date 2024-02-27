//
//  ErrorResponse.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 18/02/2024.
//

import Foundation

struct ErrorResponse: Codable {
    var error: String?
    var phone: [String]?
    var message: String?
}
