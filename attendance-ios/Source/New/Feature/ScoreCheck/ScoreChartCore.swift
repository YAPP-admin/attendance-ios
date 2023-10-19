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
    
    let sessionList: [Session] = []
  }
  
  enum Action: Equatable {
    case setStatusList([Status])
  }
  
  var body: some ReducerProtocolOf<Self> {
    Reduce { state, action in
      switch action {
      case let .setStatusList(status):
        
        state.score = status.map { $0.point }.reduce(0) { $0 + $1 }
        
        print(state.score)
        
        return .none
      default:
        return .none
      }
    }
  }
}
