//
//  OnBoardingCoordinatorView.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/10/24.
//

//import SwiftUI
//
//import ComposableArchitecture
//
//struct OnBoardingCoordinatorView: View {
//    
//    let store: StoreOf<OnBoardingCoordinator>
//    
//    var body: some View {
//      WithViewStore(self.store, observe:  { $0 }) { viewStore in
//        
//        NavigationStackStore(
//          self.store.scope(
//            state: \.path,
//            action: { .path($0) })
//        ) {
//          OnboardingView(
//            store: self.store.scope(
//              state: \.onboarding,
//              action: OnBoardingCoordinator.Action.onboarding)
//          )
//        } destination: {
//          switch $0 {
//          case .signUpName:
//            CaseLet(
//              state: /OnBoardingCoordinator.Path.State.signUpName,
//              action: OnBoardingCoordinator.Path.Action.signUpName,
//              then: SignUpNameView.init(store:)
//            )
//          case .signUpPosition:
//              CaseLet(
//                state: /OnBoardingCoordinator.Path.State.signUpPosition,
//                action: OnBoardingCoordinator.Path.Action.signUpPosition,
//                then: SignUpPositionView.init(store:)
//              )
//          case .signUpCode:
//              CaseLet(
//                state: /OnBoardingCoordinator.Path.State.signUpCode,
//                action: OnBoardingCoordinator.Path.Action.signUpCode,
//                then: SignUpCodeView.init(store:)
//              )
//          case .homeTab:
//            CaseLet(
//              state: /OnBoardingCoordinator.Path.State.homeTab,
//              action: OnBoardingCoordinator.Path.Action.homeTab,
//              then: HomeTabView.init(store:)
//            )
//          }
//        }
//        .tint(Color.gray_800)
//      }
//    }
//}
