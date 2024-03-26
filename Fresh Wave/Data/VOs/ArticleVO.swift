//
//  ArticleVO.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 22/03/2024.
//

import Foundation

// MARK: - Welcome
struct ArticleResponse: Codable {
    let data: [ArticleVO]?
    let pagination: PaginationVO?
}

// MARK: - Datum
struct ArticleVO: Codable {
    let id: Int?
    let title, description: String?
    let userID: Int?
    let imageURL: String?
    let status: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, title, description
        case userID = "user_id"
        case imageURL = "image_url"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Pagination
struct PaginationVO: Codable {
    let currentPage, total, perPage: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case total
        case perPage = "per_page"
    }
}
