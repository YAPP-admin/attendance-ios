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
    var todaySessionCoordinator: TodaySessionCoordinator.State
    var scoreCoordinator: ScoreCoordinator.State
    
    @BindingState var selectedTab: Tab
    
    init(member: Member?, selectTab: Tab) {
      self.todaySessionCoordinator = TodaySessionCoordinator.State(member: member)
      self.scoreCoordinator = ScoreCoordinator.State(member: member)
      selectedTab = selectTab
    }
  }
  
  enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    case todaySessionCoordinator(TodaySessionCoordinator.Action)
    case scoreCoordinator(ScoreCoordinator.Action)
    case tappedSettingButton
  }
  
  var body: some ReducerProtocolOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .tappedSettingButton:
        return .send(.todaySessionCoordinator(.pushSetting))
      default:
        return .none
      }
    }
    
    Scope(state: \.todaySessionCoordinator, action: /Action.todaySessionCoordinator) {
      TodaySessionCoordinator()
    }
    
    Scope(state: \.scoreCoordinator, action: /Action.scoreCoordinator) {
      ScoreCoordinator()
    }
  }
}
