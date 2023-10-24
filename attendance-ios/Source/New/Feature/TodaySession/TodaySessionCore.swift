//
//  TodaySessionCore.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/12.
//

import Foundation

import ComposableArchitecture

struct TodaySession: ReducerProtocol {
  
  struct State: Equatable {
    var session: Session?
    var member: Member?
    var isCompleteAttendance: Bool = false
    
    var sessionDate: String {
      let dateFormatter = DateFormatter()
      let sessionDateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
      let date = dateFormatter.date(from: session?.date ?? "")
      sessionDateFormatter.dateFormat = "MM.dd"
      return sessionDateFormatter.string(from: date ?? Date())
    }
    
    var sessionTitle: String {
      return session?.title ?? ""
    }
    
    var sessionDescription: String {
      return session?.description ?? ""
    }
    
    init(member: Member?) {
      self.member = member
    }
  }
  
  enum Action: Equatable {
    case showSetting
    case onAppear
    case setSession(Session?)
    case setMember(Member?)
    case pushSetting(Member?)
  }
  
  @Dependency(\.sessionInfo.sessionInfo) var sessionInfo
  
  var body: some ReducerProtocolOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { send in
          let session = try await sessionInfo.todaySession()
          await send(.setSession(session))
        } catch: { error, send in
          
        }
      case let .setSession(currentSession):
        state.session = currentSession
        return .none
      case let .setMember(member):
        state.member = member
        return .none
      default:
        return .none
      }
    }
  }
}
