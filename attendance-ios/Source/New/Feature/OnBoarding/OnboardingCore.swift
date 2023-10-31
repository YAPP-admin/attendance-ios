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
    var isFirstLaunched: Bool
    var isShowGuestButton: Bool = false
    
    init(isFirstLaunched: Bool = true) {
      self.isFirstLaunched = isFirstLaunched
    }
  }
  
  enum Action {
    case onAppear
    case setGuestButton(Bool)
    
    case launch
    case kakaoSignButtonTapped
    case guestSignButtonTapped
    case registerPlatform(String)
    case appleSignButtonTapped(name: String)
    case compareKakaoUserId(String)
    
    case pushSingUpName(String)
    case pushHomeScene(Member?)
  }
  
  @Dependency(\.kakaoSign) var kakaoSign
  @Dependency(\.appleSign) var appleSign
  @Dependency(\.memberInfo) var memberInfo
  @Dependency(\.config.remoteConfig) var config
  
  var body: some ReducerProtocolOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { send in
          let isShow = try await config.shouldShowGuestButton()
          
          await send(.setGuestButton(isShow))
        }
      case let .setGuestButton(isShow):
        state.isShowGuestButton = isShow
        return .none
      case .launch:
        state.isLaunching = true
        return .none
      case .kakaoSignButtonTapped:
        
        return .run { send in
          try await kakaoSign.login()
          let userId = try await kakaoSign.getUserId()
          
          await send(.compareKakaoUserId(userId))
        } catch: { error, send in
          print(error)
          await send(.pushSingUpName(""))
        }
        
      case let .compareKakaoUserId(userId):
        return .run { send in
         let member = try await memberInfo.memberInfo.getMemberInfo(memberId: Int(userId) ?? 0)
          
          try await KeyChainManager.shared.create(account: .userId, data: userId)
          try await KeyChainManager.shared.create(account: .platform, data: "kakao")
          await send(.pushHomeScene(member))
          
        } catch: { error, send in
          print(error)
          await send(.registerPlatform("kakao"))
          await send(.pushSingUpName(""))
        }
        
      case let .appleSignButtonTapped(name):
        return .run { send in
          let userId = try await KeyChainManager.shared.read(account: .userId)
          let platform = try await KeyChainManager.shared.read(account: .platform)
          
          if platform == "apple" {
            let member = try await memberInfo.memberInfo.getMemberInfo(memberId: Int(userId) ?? 0)
             
             try await KeyChainManager.shared.create(account: .userId, data: userId)
             try await KeyChainManager.shared.create(account: .platform, data: "apple")
             await send(.pushHomeScene(member))
          }
          
        } catch: { error, send in
          await send(.registerPlatform("apple"))
          await send(.pushSingUpName(name))
        }
      case let .registerPlatform(platform):
        return .run { send in
          try await KeyChainManager.shared.create(account: .platform, data: platform)
        }
        
      case .guestSignButtonTapped:
        
        return .run { send in
          
          let member = try await memberInfo.memberInfo.getMemberInfo(memberId: 2920795262)
          await send(.pushHomeScene(member))
        } catch: { error, send in
          print(error)
        }
      default:
        return .none
      }
    }
  }
}
