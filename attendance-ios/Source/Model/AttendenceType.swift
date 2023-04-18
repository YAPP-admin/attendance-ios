//
//  AttendenceType.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/04/19.
//

import Foundation

/// 레거시 -> Status로 통일할 예정

enum AttendanceType: Int, Codable, CaseIterable {
    case attendance
    case tardy
    case absence
    case attendanceMarked

    var text: String {
        switch self {
        case .attendance: return "출석"
        case .tardy: return "지각"
        case .absence: return "결석"
        case .attendanceMarked: return "출석 인정"
        }
    }

    var point: Int {
        switch self {
        case .attendance: return 0
        case .tardy: return -10
        case .absence: return -20
        case .attendanceMarked: return 0
        }
    }
}

enum NeedToAttendType: String, Codable {
    case needAttendance = "NEED_ATTENDANCE"
    case dontNeedAttendance = "DONT_NEED_ATTENDANCE"
    case dayOff = "DAY_OFF"
}
