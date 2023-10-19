//
//  ScoreCheckCore.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/16.
//

import Foundation

import ComposableArchitecture

enum SessionStatus {
  case attendance
  case absent
  case late
  case admit
  case notNeed
  case pre
}

struct ScoreCheck: ReducerProtocol {

  struct State: Equatable {
    
    var sessionList: IdentifiedArrayOf<SessionItem.State> = []
    var scoreChart = ScoreChart.State()
    
    let member: Member?
    
    init(member: Member?) {
      self.member = member
    }
  }
  
  enum Action: Equatable {
    case sessionList(SessionItem.State.ID, SessionItem.Action)
    case scoreChart(ScoreChart.Action)
    
    case onAppear
    case setSessionList([Session])
  }
  
  @Dependency(\.sessionInfo.sessionInfo) var sessionInfo
  
  var body: some ReducerProtocolOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { send in
          let sessions = try await sessionInfo.getSessionList()
        
          await send(.setSessionList(sessions))
        }
      case let .setSessionList(sessions):
        guard let member = state.member else {
          return .none
        }
        
        var sessionStatus: [Status] = []
        
        sessions.forEach { session in
          if let attendance = member.attendances.filter({ $0.sessionId == session.sessionId }).first {
      
            if session.type == .dontNeedAttendance {
              state.sessionList.updateOrAppend(.init(session: session, status: .notNeed))
            } else if Date().isPast(than: session.date.date()) == false {
              state.sessionList.updateOrAppend(.init(session: session, status: .pre))
            } else {
              state.sessionList.updateOrAppend(.init(session: session, status: attendance.status.convertSessionStatus()))
              sessionStatus.append(attendance.status)
            }
          }
        }
        
        return .run { [sessionStatus = sessionStatus] send in
          await send(.scoreChart(.setStatusList(sessionStatus)))
        }
      default:
        return .none
      }
    }
    .forEach(\.sessionList, action: /Action.sessionList) {
      SessionItem()
    }
    
    Scope(state: \.scoreChart, action: /Action.scoreChart) {
      ScoreChart()
    }
  }
}

extension Status {
  func convertSessionStatus() -> SessionStatus {
    switch self {
    case .normal:
      return .attendance
    case .late:
      return .late
    case .absent:
      return .absent
    case .admit:
      return .admit
    }
  }
}

