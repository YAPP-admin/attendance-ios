//
//  TodaySessionCoordinatorView.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/10/23.
//

import SwiftUI

import ComposableArchitecture

struct TodaySessionCoordinatorView: View {
    
    let store: StoreOf<TodaySessionCoordinator>
    
    var body: some View {
      WithViewStore(self.store, observe:  { $0 }) { viewStore in
        
        NavigationStackStore(
          self.store.scope(
            state: \.path,
            action: { .path($0) })
        ) {
          TodaySessionView(
            store: self.store.scope(
              state: \.todaySession,
              action: TodaySessionCoordinator.Action.todaySession)
          )
        } destination: {
          switch $0 {
          case .setting:
            CaseLet(
              state: /TodaySessionCoordinator.Path.State.setting,
              action: TodaySessionCoordinator.Path.Action.setting,
              then: SettingView.init(store:)
            )
          }
        }
        .tint(Color.gray_800)
      }
    }
}
