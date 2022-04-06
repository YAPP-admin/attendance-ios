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
    let isOff: Bool

    enum CodingKeys: String, CodingKey {
        case sessionId = "session_id"
        case title
        case date
        case description
        case isOff = "is_off"
    }
}

enum PositionType: String, Codable {
    case android = "DEV_ANDROID"
    case web = "DEV_WEB"
    case ios = "DEV_IOS"
    case server = "DEV_SEVER"
    case designer = "DESIGNER"
    case projectManager = "PROJECT_MANAGER"
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
}

struct Attendance: Codable {
    let sesstionId: Int
    let attendanceType: AttendanceType
}

enum AttendanceType: Int, Codable {
    case absence
    case tardy
    case attendance
    case attendanceMarked

    var text: String {
        switch self {
        case .absence: return "결석"
        case .tardy: return "지각"
        case .attendance: return "출석"
        case .attendanceMarked: return "출석 인정"
        }
    }

    var point: Int {
        switch self {
        case .absence: return -10
        case .tardy: return -5
        case .attendance: return 0
        case .attendanceMarked: return 0
        }
    }
}

enum NeedToAttendType: String {
    case needAttendance = "NEED_ATTENDANCE"
    case dontNeedAttendance = "DONT_NEED_ATTENDANCE"
    case dayOff = "DAY_OFF"
}
