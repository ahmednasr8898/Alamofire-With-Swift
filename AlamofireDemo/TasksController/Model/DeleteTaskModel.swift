//
//  DeleteTaskModel.swift
//  AlamofireDemo
//
//  Created by Ahmed Nasr on 11/26/20.
//
import Foundation

// MARK: - DeleteTaskModel
struct DeleteTaskModel: Codable {
    let status: Int?
    let msg, taskID: String?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case taskID = "task_id"
    }
}
