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

struct Session {
    let sessionId: Int
    let title: String
    let date: String // yyyy-mm-dd
    let description: String
}

struct Config {
    let generation: Int
    let sessionCount: Int
    let adminPassword: String
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
    case empty

    var point: Int {
        switch self {
        case .notMentionedAbsence: return -20
        case .absence: return -10
        case .attendance: return 0
        case .notMentionedTardy: return -10
        case .tardy: return -5
        case .empty: return 0
        }
    }
}
