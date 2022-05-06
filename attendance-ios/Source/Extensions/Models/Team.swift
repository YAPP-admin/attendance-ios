//
//  Team.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/05/05.
//

import Foundation

extension Team {

    func name() -> String {
        return "\(self.type.lowerCase) \(self.number)팀"
    }

}
