//
//  Attendance.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/04/07.
//

import Foundation

struct Attendance: Codable {
    let sessionId: Int
    var status: Status
}

struct AttendanceDTO: Codable {
    let sessionId: Int
    var status: String
  
    func convert() -> Attendance {
      return Attendance(sessionId: self.sessionId, status: self.statusToEntity(from: self.status))
    }
  
  func statusToEntity(from status: String) -> Status {
    switch status {
    case "ABSENT":
      return .absent
    case "LATE":
      return .late
    case "ADMIT":
      return .admit
    case "NORMAL":
      return .normal
    default:
      return .normal
    }
  }
}

