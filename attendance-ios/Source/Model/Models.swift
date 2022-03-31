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
    let team: Team
    let attendances: [Attendance]
}

struct Session: Codable {
    let sessionId: Int
    let title: String
    let date: String // yyyy-mm-dd
    let description: String

    enum CodingKeys: String, CodingKey {
        case sessionId = "session_id"
        case title
        case date
        case description
    }
}

struct Team: Codable {
    var platform: PlatformType
    var teamNumber: Int
}

struct Attendance: Codable {
    let sesstionId: Int
    let attendanceType: AttendanceType
}

enum PlatformType: String, Codable {
    case allRounder = "All-Rounder"
    case android = "Android"
    case ios = "iOS"
    case web = "Web"

    enum CodingKeys: String, CodingKey {
        case allRounder = "All-Rounder"
        case android = "Android"
        case ios = "iOS"
        case web = "Web"
    }
}

enum AttendanceType: Int, Codable {
    case notMentionedAbsence
    case absence
    case attendance
    case notMentionedTardy
    case tardy

    var text: String {
        switch self {
        case .notMentionedAbsence: return "미통보 결석"
        case .absence: return "결석"
        case .attendance: return "출석"
        case .notMentionedTardy: return "미통보 지각"
        case .tardy: return "지각"
        }
    }

    var point: Int {
        switch self {
        case .notMentionedAbsence: return -20
        case .absence: return -10
        case .attendance: return 0
        case .notMentionedTardy: return -10
        case .tardy: return -5
        }
    }
}
