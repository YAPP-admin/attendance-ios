//
//  Team.swift
//  attendance-ios
//
//  Created by 김나희 on 5/7/23.
//

import Foundation

protocol DisplayableItem {
    func displayName() -> String
}

struct Team: Codable, Equatable {
    var type: TeamType
    var number: Int
}

extension Team: DisplayableItem {
    func displayName() -> String {
        return "\(self.type.lowerCase) \(self.number)"
    }
}

enum TeamType: String, Codable {
    case android = "ANDROID"
    case ios = "IOS"
    case web = "WEB"
    case basecamp = "BASECAMP"
    case none = "NONE"

    var upperCase: String {
        switch self {
        case .android: return "ANDROID"
        case .ios: return "IOS"
        case .web: return "WEB"
        case .basecamp: return "BASECAMP"
        case .none: return "NONE"
        }
    }

    var lowerCase: String {
        switch self {
        case .android: return "Android"
        case .ios: return "iOS"
        case .web: return "Web"
        case .basecamp: return "Basecamp"
        case .none: return "None"
        }
    }
}
