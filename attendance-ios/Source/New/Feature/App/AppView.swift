//
//  AppView.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/13.
//

import SwiftUI

import ComposableArchitecture

struct AppView: View {
    
    let store: StoreOf<App>
    
    var body: some View {
        NavigationStackStore(self.store.scope(state: \.path, action: { .path($0) })) {
          OnboardingView(
            store: self.store.scope(state: \.onboarding, action: { .onboarding($0) })
          )
        } destination: {
          switch $0 {
          case .signUpName:
            CaseLet(
              state: /App.Path.State.signUpName,
              action: App.Path.Action.signUpName,
              then: SignUpNameView.init(store:)
            )
          case .signUpPosition:
              CaseLet(
                state: /App.Path.State.signUpPosition,
                action: App.Path.Action.signUpPosition,
                then: SignUpPositionView.init(store:)
              )
          case .signUpCode:
              CaseLet(
                state: /App.Path.State.signUpCode,
                action: App.Path.Action.signUpCode,
                then: SignUpCodeView.init(store:)
              )
          case .homeTab:
              CaseLet(
                state: /App.Path.State.homeTab,
                action: App.Path.Action.homeTab,
                then: HomeTabView.init(store:)
              )
          }
        }
        .tint(Color.gray_800)
    }
}
