//
//  Attendance.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/04/07.
//

import Foundation

struct Attendance: Codable {
    let sesstionId: Int
    let type: AttendanceType
}

struct AttendanceType: Codable {
    let point: Int
    let text: String
}

enum AttendanceCase: Int, Codable {
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
        case .absence: return -20
        case .tardy: return -10
        case .attendance: return 0
        case .attendanceMarked: return 0
        }
    }
}

enum NeedToAttendType: String, Codable {
    case needAttendance = "NEED_ATTENDANCE"
    case dontNeedAttendance = "DONT_NEED_ATTENDANCE"
    case dayOff = "DAY_OFF"
}
