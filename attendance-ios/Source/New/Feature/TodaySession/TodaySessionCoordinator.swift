//
//  TodaySessionCoordinator.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/10/23.
//

import Foundation

import ComposableArchitecture

struct TodaySessionCoordinator: ReducerProtocol {
  
  struct State: Equatable {
    var path = StackState<Path.State>()
    var todaySession: TodaySession.State
    var member: Member?
    
    init(member: Member?) {
      self.todaySession = TodaySession.State(member: member)
      self.member = member
    }
  }
  
  enum Action {
    case path(StackAction<Path.State, Path.Action>)
    
    case todaySession(TodaySession.Action)
    case pushSetting
  }
  
  var body: some ReducerProtocolOf<Self> {
    
    Reduce<State, Action> { state, action in
      switch action {
      case .pushSetting:
        state.path.append(Path.State.setting(Setting.State(member: state.member)))
        return .none
      case let .path(.element(id: id, action: .setting(.setMemberInfo(member)))):
        
        guard case .some(.setting) = state.path[id: id]
        else { return .none }
        
        state.member = member
        return .none
      default:
        return .none
      }
    }
    .forEach(\.path, action: /Action.path) {
      Path()
    }
    
    Scope(state: \.todaySession, action: /Action.todaySession) {
      TodaySession()
    }
  }
}

extension TodaySessionCoordinator {
    struct Path: ReducerProtocol {
        enum State: Equatable {
            case setting(Setting.State)
        }
        
        enum Action {
            case setting(Setting.Action)
        }
        
        var body: some ReducerProtocolOf<Self> {
            Scope(state: /State.setting, action: /Action.setting) {
              Setting()
            }
        }
    }
}
