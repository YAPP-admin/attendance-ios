//
//  ScoreChartCore.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/10/20.
//

import Foundation

import ComposableArchitecture

struct ScoreChart: ReducerProtocol {
  
  struct State: Equatable {
    
    var score: Int = 0
    
    var attendanceCount: Int = 0
    var lateCount: Int = 0
    var absentCount: Int = 0
    
  }
  
  enum Action: Equatable {
    case setStatusList([Status])
  }
  
  var body: some ReducerProtocolOf<Self> {
    Reduce { state, action in
      switch action {
      case let .setStatusList(status):
        state.score = status.map { $0.point }.reduce(0) { $0 + $1 }
        
        state.attendanceCount = status.filter { $0 == .admit && $0 == .normal }.count
        state.lateCount = status.filter { $0 == .late }.count
        state.absentCount = status.filter { $0 == .absent }.count
        
        return .none
      }
    }
  }
}
