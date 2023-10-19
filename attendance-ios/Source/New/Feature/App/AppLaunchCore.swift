//
//  AppLaunchCore.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/10/15.
//

import Foundation

import ComposableArchitecture

struct AppLaunch: ReducerProtocol {
  
  enum State: Equatable {
    case onboarding(Onboarding.State)
    case tab(HomeTab.State)
  }
  
  enum Action {
    case onboarding(Onboarding.Action)
    case tab(HomeTab.Action)
  }
  
  var body: some ReducerProtocolOf<Self> {
    Reduce { state, action in
      switch action {
        
      default:
        return .none
      }
    }
    .ifCaseLet(/State.onboarding, action: /Action.onboarding) {
      Onboarding()
    }
    .ifCaseLet(/State.tab, action: /Action.tab) {
      HomeTab()
    }
    
  }
}
