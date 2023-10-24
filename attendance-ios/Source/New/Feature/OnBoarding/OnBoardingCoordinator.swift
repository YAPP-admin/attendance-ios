//
//  OnBoardingCoordinator.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/10/24.
//

import Foundation

import ComposableArchitecture

//struct OnBoardingCoordinator: ReducerProtocol {
//  
//  struct State: Equatable {
//    var path = StackState<Path.State>()
//    var onboarding: Onboarding.State
//    
//    init() {
//      self.onboarding = Onboarding.State()
//    }
//  }
//  
//  enum Action {
//    case path(StackAction<Path.State, Path.Action>)
//    
//    case onboarding(Onboarding.Action)
//  }
//  
//  var body: some ReducerProtocolOf<Self> {
//    
//    Reduce<State, Action> { state, action in
//      switch action {
//      case let .onboarding(.pushSingUpName(userName)):
//
//        state.path.append(OnBoardingCoordinator.Path.State.signUpName(SignUpName.State(userName: userName)))
//
//        return .none
//        
//      case let .onboarding(.pushHomeScene(member)):
//
//        state.path.append(OnBoardingCoordinator.Path.State.homeTab(.init(member: member, selectTab: .todaySession)))
//
//        return .none
//        
//      case let .path(.element(id: _, action: .signUpCode(.pushHomeTab(member)))):
//
//        state.path.append(OnBoardingCoordinator.Path.State.homeTab(.init(member: member, selectTab: .todaySession)))
//
//        return .none
//        
//      default:
//        return .none
//      }
//    }
//    .forEach(\.path, action: /Action.path) {
//      Path()
//    }
//    
//    Scope(state: \.onboarding, action: /Action.onboarding) {
//      Onboarding()
//    }
//  }
//}
//
//extension OnBoardingCoordinator {
//    struct Path: ReducerProtocol {
//        enum State: Equatable {
//            case homeTab(HomeTab.State)
//          case signUpName(SignUpName.State)
//          case signUpPosition(SignUpPosition.State)
//          case signUpCode(SignUpCode.State)
//        }
//        
//        enum Action {
//            case homeTab(HomeTab.Action)
//          
//          case signUpName(SignUpName.Action)
//          case signUpPosition(SignUpPosition.Action)
//          case signUpCode(SignUpCode.Action)
//        }
//        
//        var body: some ReducerProtocolOf<Self> {
//          Scope(state: /State.signUpName, action: /Action.signUpName) {
//            SignUpName()
//          }
//          
//          Scope(state: /State.signUpPosition, action: /Action.signUpPosition) {
//            SignUpPosition()
//          }
//          
//          Scope(state: /State.signUpCode, action: /Action.signUpCode) {
//            SignUpCode()
//          }
//          
//          Scope(state: /State.homeTab, action: /Action.homeTab) {
//            HomeTab()
//          }
//        }
//    }
//}
