//
//  Session.swift
//  attendance-ios
//
//  Created by 김나희 on 5/7/23.
//

import Foundation

struct Session: Codable, Equatable {
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

enum NeedToAttendType: String, Codable {
    case needAttendance = "NEED_ATTENDANCE"
    case dontNeedAttendance = "DONT_NEED_ATTENDANCE"
    case dayOff = "DAY_OFF"
}
