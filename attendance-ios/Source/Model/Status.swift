//
//  Status.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/04/19.
//

import UIKit

enum Status: Codable, CaseIterable {
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
        case .absent: return "결석"
        case .late: return "지각"
        case .admit: return "출석 인정"
        case .normal: return "출석"
        }
    }

    var point: Int {
        switch self {
        case .normal: return 0
        case .late: return -10
        case .absent: return -20
        case .admit: return 0
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
