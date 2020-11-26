//
//  LoginModel.swift
//  AlamofireDemo
//
//  Created by Ahmed Nasr on 11/25/20.
//

import Foundation
// MARK: - LoginModel
struct LoginModel: Codable {
    let status: Int?
    let user: User?
    let msg: String?
}

// MARK: - User
struct User: Codable {
    let id: Int?
    let name, email, apiToken, createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, email
        case apiToken = "api_token"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
