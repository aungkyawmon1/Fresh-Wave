//
//  UserVO.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 14/03/2024.
//

import Foundation

// MARK: - LoginRespone
struct LoginResponse: Codable {
    let accessToken, tokenType: String?
    let expiresIn: Int?
    let user: UserVO?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case user
    }
}

// MARK: - User
struct UserVO: Codable {
    let id: Int?
    let username, password, phoneNo, latitude: String?
    let longitude, address, createdDate, updatedDate: String?
    let status, roleID: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, username, password
        case phoneNo = "phone_no"
        case latitude, longitude, address
        case createdDate = "created_date"
        case updatedDate = "updated_date"
        case status
        case roleID = "role_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
