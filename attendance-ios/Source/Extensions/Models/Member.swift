//
//  Member.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/05/05.
//

import Foundation

extension Member {

    func totalGrade(until sessionId: Int) -> Int {
        let attendances = self.attendances.filter { $0.sessionId <= sessionId }
        let totalGrade = attendances.reduce(100, { $0 + $1.type.point })
        return max(totalGrade, 0)
    }

}
