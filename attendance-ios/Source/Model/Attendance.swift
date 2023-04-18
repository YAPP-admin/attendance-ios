//
//  Attendance.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/04/07.
//

import Foundation

struct Attendance: Codable {
    let sessionId: Int
    var status: Status
}

enum Status: Codable {
    case absent 
    case late
    case admit
    case normal
    
    var serverText: String {
        switch self {
        case .absent: return "ABSENT"
        case .late: return "LATE"
        case .admit: return "ADMIT"
        case .normal: return "NORMAL"
        }
    }
    
    var text: String {
        switch self {
        case .absent: return "출석"
        case .late: return "지각"
        case .admit: return "결석"
        case .normal: return "출석 인정"
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
