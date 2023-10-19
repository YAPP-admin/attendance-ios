//
//  PositionType.swift
//  attendance-ios
//
//  Created by 김나희 on 5/7/23.
//

import Foundation

enum Position: String, CaseIterable, Codable, Equatable {
    case projectManager = "PROJECT_MANAGER"
    case designer = "DESIGNER"
    case android = "DEV_ANDROID"
    case ios = "DEV_IOS"
    case web = "DEV_WEB"
    case server = "DEV_SERVER"

    var shortValue: String {
        switch self {
        case .projectManager: return "PM"
        case .designer: return "UX/UI Design"
        case .android: return "Android"
        case .ios: return "iOS"
        case .web: return "Web"
        case .server: return "Server"
        }
    }
}

extension Position: DisplayableItem {
    func displayName() -> String {
        return "\(self.shortValue)"
    }
}
