//
//  TodaySessionCoordinator.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/10/23.
//

import Foundation

import ComposableArchitecture
//
//struct TodaySessionCoordinator: ReducerProtocol {
//  
//  struct State: Equatable {
//    var path = StackState<Path.State>()
//    var todaySession: TodaySession.State
//    var member: Member?
//    
//    init(member: Member?) {
//      self.todaySession = TodaySession.State(member: member)
//      self.member = member
//    }
//  }
//  
//  enum Action {
//    case path(StackAction<Path.State, Path.Action>)
//    
//    case todaySession(TodaySession.Action)
//    case pushSetting
//    case popToRoot
//  }
//  
//  var body: some ReducerProtocolOf<Self> {
//    
//    Reduce<State, Action> { state, action in
//      switch action {
//      
//      default:
//        return .none
//      }
//    }
//    .forEach(\.path, action: /Action.path) {
//      Path()
//    }
//    
//    Scope(state: \.todaySession, action: /Action.todaySession) {
//      TodaySession()
//    }
//  }
//}
//
//extension TodaySessionCoordinator {
//    struct Path: ReducerProtocol {
//        enum State: Equatable {
//            case setting(Setting.State)
//        }
//        
//        enum Action {
//            case setting(Setting.Action)
//        }
//        
//        var body: some ReducerProtocolOf<Self> {
            
//        }
//    }
//}
