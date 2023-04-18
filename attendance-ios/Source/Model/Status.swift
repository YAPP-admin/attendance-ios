//
//  Status.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/04/19.
//

import UIKit

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

extension Status {
    var textColor: UIColor {
        switch self {
        case .absent:
            return .etc_red
        case .late:
            return .etc_yellow_font
        case .normal, .admit:
            return .etc_green
        }
    }
    
    var image: UIImage? {
        switch self {
        case .absent:
            return UIImage(named: "absence")
        case .late:
            return UIImage(named: "tardy")
        case .normal, .admit:
            return UIImage(named: "attendance")
        }
    }
}
