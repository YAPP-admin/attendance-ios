//
//  Session.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/05/05.
//

import Foundation

extension Array where Element == Session {

    func todaySession() -> Session? {
        guard let nowDate = Date().startDate() else { return nil }
        lazy var sessions = self.filter { nowDate.isFuture(than: $0.date.date()) }
        return sessions.first
    }

    func totalSessionId() -> Int? {
        return self.todaySession()?.sessionId
    }

}
