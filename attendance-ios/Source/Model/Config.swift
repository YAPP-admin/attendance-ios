//
//  Config.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/03/12.
//

import Foundation

struct Config: Codable {
    let generation: Int
    let sessionCount: Int
    let adminPassword: String

    enum CodingKeys: String, CodingKey {
        case generation
        case sessionCount = "session_count"
        case adminPassword = "admin_password"
    }

}

struct ConfigTeam: Codable {
    let team: String
    let count: String
}
