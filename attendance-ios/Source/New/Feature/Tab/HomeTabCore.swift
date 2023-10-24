//
//  HomeTabCore.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/16.
//

import Foundation

import ComposableArchitecture
import SwiftUI

struct HomeTab: ReducerProtocol {
  
  enum Tab { case todaySession, qr, scoreCheck}
  
  struct State: Equatable {
    var todaySession: TodaySession.State
    var scoreCheck: ScoreCheck.State
    
    @BindingState var selectedTab: Tab
    
    var member: Member?
    
    init(member: Member?, selectTab: Tab) {
      self.todaySession = TodaySession.State(member: member)
      self.scoreCheck = ScoreCheck.State(member: member)
      selectedTab = selectTab
      self.member = member
    }
  }
  
  enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    case todaySession(TodaySession.Action)
    case scoreCheck(ScoreCheck.Action)
    case tappedSettingButton(Member?)
    case setMember(Member?)
  }
  
  var body: some ReducerProtocolOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .tappedSettingButton:
        return .none
      case let .setMember(member):
        state.member = member
        return .none
      default:
        return .none
      }
    }
    
    Scope(state: \.todaySession, action: /Action.todaySession) {
      TodaySession()
    }
    
    Scope(state: \.scoreCheck, action: /Action.scoreCheck) {
      ScoreCheck()
    }
  }
}
