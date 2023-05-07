//
//  Member.swift
//  attendance-ios
//
//  Created by 김나희 on 5/7/23.
//

import Foundation

struct Member: Codable {
    let id: Int
    let name: String
    let position: Position
    let team: Team
    var attendances: [Attendance]
}

struct MemberDTO: Codable {
    let id: Int
    let name: String
    let position: Position
    let team: Team
    var attendances: [AttendanceDTO]
  
    func convert() -> Member {
      return Member(
        id: self.id,
        name: self.name,
        position: self.position,
        team: self.team,
        attendances: attendances.map { $0.convert() }
      )
    }
}
