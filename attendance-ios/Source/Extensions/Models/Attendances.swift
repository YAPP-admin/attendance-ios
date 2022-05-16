//
//  Attendances.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/05/16.
//

import Foundation

extension Array where Element == Attendance {

    func decode() -> [[String: Any]] {
        var attendances: [[String: Any]] = []
        self.forEach {
            let attendance: [String: Any] = ["sessionId": $0.sessionId,
                                       "type": ["text": $0.type.text, "point": $0.type.point]]
            attendances.append(attendance)
        }
        return attendances
    }

}
