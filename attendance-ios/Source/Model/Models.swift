//
//  File.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/03/12.
//

import Foundation

struct Member {
    let id: Int
    let name: String
    let position: String
    let team: Team
    let isAdmin: Bool
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

enum PositionType {
    case frontend
    case backend
    case designer
    case projectManager
}

struct Team {
    let platform: PlatformType
    let teamNumber: Int
}

struct Attendance {
    let sesstionId: Int
    let attendanceType: AttendanceType
}

enum PlatformType {
    case android
    case ios
    case web
}

enum AttendanceType: Int {
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
