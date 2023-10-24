//
//  ScoreCheckPath.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/10/22.
//

//import Foundation
//
//import ComposableArchitecture
//
//struct ScoreCoordinator: ReducerProtocol {
//  
//  struct State: Equatable {
//    var path = StackState<Path.State>()
//    var scoreCheck: ScoreCheck.State
//    
//    init(member: Member?) {
//      self.scoreCheck = ScoreCheck.State(member: member)
//    }
//  }
//  
//  enum Action {
//    case path(StackAction<Path.State, Path.Action>)
//    
//    case scoreCheck(ScoreCheck.Action)
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
//    Scope(state: \.scoreCheck, action: /Action.scoreCheck) {
//      ScoreCheck()
//    }
//  }
//}
//
//extension ScoreCoordinator {
//    struct Path: ReducerProtocol {
//        enum State: Equatable {
//            case scoreInfo(ScoreInfo.State)
////            case signUpPosition(SignUpPosition.State)
////            case signUpCode(SignUpCode.State)
////
////            case homeTab(HomeTab.State)
//        }
//        
//        enum Action {
//            case scoreInfo(ScoreInfo.Action)
////            case signUpPosition(SignUpPosition.Action)
////            case signUpCode(SignUpCode.Action)
////
////            case homeTab(HomeTab.Action)
//        }
//        
//        var body: some ReducerProtocolOf<Self> {
//            Scope(state: /State.scoreInfo, action: /Action.scoreInfo) {
//                EmptyReducer()
//            }
////
////            Scope(state: /State.signUpPosition, action: /Action.signUpPosition) {
////                SignUpPosition()
////            }
////
////            Scope(state: /State.signUpCode, action: /Action.signUpCode) {
////                SignUpCode()
////            }
////
////            Scope(state: /State.homeTab, action: /Action.homeTab) {
////                HomeTab()
////            }
//        }
//    }
//}
//
//
