//
//  OnboardingCore.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/08.
//

import Foundation

import ComposableArchitecture

struct Onboarding: ReducerProtocol {
  
  struct State: Equatable {
    var isLaunching: Bool = false
  }
  
  enum Action {
    case launch
    case kakaoSignButtonTapped
    case appleSignButtonTapped
    case compareUserId(String)
    
    case pushSingUpName(String)
    case pushHomeScene(Member?)
  }
  
  @Dependency(\.kakaoSign) var kakaoSign
  @Dependency(\.appleSign) var appleSign
  @Dependency(\.memberInfo) var memberInfo
  
  var body: some ReducerProtocolOf<Self> {
    Reduce { state, action in
      switch action {
      case .launch:
        state.isLaunching = true
        return .none
      case .kakaoSignButtonTapped:
        
        return .run { send in
          try await kakaoSign.login()
          let userId = try await kakaoSign.getUserId()
          
          await send(.compareUserId(userId))
        } catch: { error, send in
          print(error)
          await send(.pushSingUpName(""))
        }
        
      case let .compareUserId(userId):
        return .run { send in
         let member = try await memberInfo.memberInfo.getMemberInfo(memberId: Int(userId) ?? 0)
          
          try await KeyChainManager.shared.create(account: .userId, data: userId)
          await send(.pushHomeScene(member))
          
        }catch: { error, send in
          await send(.pushSingUpName(""))
        }
        
      case .appleSignButtonTapped:
        return .run { send in
          let name = try await appleSign.login()
          await send(.pushSingUpName(name))
        } catch: { error, send in
          //
        }
        
      default:
        return .none
      }
    }
  }
}
