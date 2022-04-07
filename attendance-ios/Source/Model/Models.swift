//
//  File.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/03/12.
//

import Foundation

struct Member: Codable {
    let id: Int
    let name: String
    let position: PositionType
    let team: Team
    let attendances: [Attendance]
}

struct Session: Codable {
    let sessionId: Int
    let title: String
    let date: String // yyyy-mm-dd hh:mm:ss
    let description: String
    let type: NeedToAttendType

    enum CodingKeys: String, CodingKey {
        case sessionId = "session_id"
        case title
        case date
        case description
        case type
    }
}

enum PositionType: String, CaseIterable, Codable {
    case projectManager = "PROJECT_MANAGER"
    case designer = "DESIGNER"
    case android = "DEV_ANDROID"
    case ios = "DEV_IOS"
    case web = "DEV_WEB"
    case server = "DEV_SEVER"

    var shortValue: String {
        switch self {
        case .android: return "Android"
        case .web: return "Web"
        case .ios: return "iOS"
        case .server: return "Server"
        case .designer: return "UX/UI Design"
        case .projectManager: return "PM"
        }
    }
}

struct Team: Codable {
    var type: TeamType
    var number: Int
}

enum TeamType: String, Codable {
    case android = "Android"
    case ios = "iOS"
    case web = "Web"
    case allRounder = "All-Rounder"
}
