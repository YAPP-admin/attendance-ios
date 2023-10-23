//
//  AppLaunchView.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/10/15.
//

import SwiftUI

import ComposableArchitecture

struct AppLaunchView: View {
    
    let store: StoreOf<AppLaunch>
    
    var body: some View {
      SwitchStore(self.store) {
        CaseLet(/AppLaunch.State.onboarding, action: AppLaunch.Action.onboarding) { store in
          OnboardingView(store: store)
        }
        
        CaseLet(/AppLaunch.State.tab, action: AppLaunch.Action.tab) { store in
          HomeTabView(store: store)
        }
      }
    }
}
