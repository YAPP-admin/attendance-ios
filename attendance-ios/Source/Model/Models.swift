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
        case .projectManager: return "PM"
        case .designer: return "UX/UI Design"
        case .android: return "Android"
        case .ios: return "iOS"
        case .web: return "Web"
        case .server: return "Server"
        }
    }
}

struct Team: Codable {
    var type: TeamType
    var number: Int
}

enum TeamType: String, Codable {
    case android = "ANDROID"
    case ios = "IOS"
    case web = "WEB"
    case allRounder = "ALL_ROUNDER"

    var lowerCase: String {
        switch self {
        case .android: return "Android"
        case .ios: return "iOS"
        case .web: return "Web"
        case .allRounder: return "All-Rounder"
        }
    }

}

//enum TeamType: String, Codable {
//    case android
//    case ios
//    case web
//    case allRounder
//
//    var upperCase: String {
//        switch self {
//        case .android: return "ANDROID"
//        case .ios: return "IOS"
//        case .web: return "WEB"
//        case .allRounder: return "ALL_ROUNDER"
//        }
//    }
//
//    var lowerCase: String {
//        switch self {
//        case .android: return "Android"
//        case .ios: return "iOS"
//        case .web: return "Web"
//        case .allRounder: return "All-Rounder"
//        }
//    }
//
//    enum CodingKeys: String, CodingKey {
//        case android = "ANDROID"
//        case ios = "IOS"
//        case web = "WEB"
//        case allRounder = "ALL_ROUNDER"
//    }
//
//}
