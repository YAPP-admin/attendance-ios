//
//  SignUpCodeCore.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/16.
//

import Foundation

import ComposableArchitecture

struct SignUpCode: ReducerProtocol {
  
  struct State: Equatable {
    @BindingState var code: String = ""
    var isEnabledNextButton: Bool = false
    var isFocus: Bool = false
    
    var firstInputView: Bool = false
    var secondInputView: Bool = false
    var thirdInputView: Bool = false
    var fourthInputView: Bool = false
    
    var isIncorrectCode: Bool = false
    var isConfirmCode: Bool = false
    
    var selectedPosition: Position
    var name: String
    
    init(name: String, selectedPosition: Position) {
      self.name = name
      self.selectedPosition = selectedPosition
    }
  }
  
  enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    
    case focus(Bool)
    case codeCheck
    case incorrectCode
    case pushHomeTab(Member?)
  }
  
  @Dependency(\.kakaoSign) var kakaoSign
  @Dependency(\.memberInfo.memberInfo) var memberInfo
  @Dependency(\.config.remoteConfig) var config
  
  var body: some ReducerProtocolOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding(\.$code):
        let count = state.code.count
        let maxInputViews = 4
        var inputViews = Array(repeating: false, count: maxInputViews)
        state.isEnabledNextButton = count == 4
        
        for index in 0..<min(count, maxInputViews) {
          inputViews[index] = true
        }
        
        state.firstInputView = inputViews[0]
        state.secondInputView = inputViews[1]
        state.thirdInputView = inputViews[2]
        state.fourthInputView = inputViews[3]
        
        return .none
      case let .focus(isFocus):
        if state.isIncorrectCode && isFocus {
          state.isIncorrectCode = false
          state.isConfirmCode = false
          state.code = ""
          state.firstInputView = false
          state.secondInputView = false
          state.thirdInputView = false
          state.fourthInputView = false
        }
        state.isFocus = isFocus
        return .none
      case .codeCheck:
        state.isConfirmCode = true
        let name = state.name
        let selectedPosition = state.selectedPosition
        
        return .run { [stateCode = state.code] send in
          let code = try await config.getSignUpPassword()
          
          if stateCode == code {

            let platform = try await KeyChainManager.shared.read(account: .platform)
            if platform == "kakao" {
              try await kakaoSign.saveUserId()
              let userID = try await KeyChainManager.shared.read(account: .userId)
              try await memberInfo.registerKakaoUser(
                memberId: Int(userID) ?? 0,
                newUserInfo: .init(
                  name: name,
                  positionType: selectedPosition,
                  teamType: .none,
                  teamNumber: 0
                )
              )
              let member = try await memberInfo.getMemberInfo(memberId: Int(userID) ?? 0)
              await send(.pushHomeTab(member))
            } else {
              let userID = Int.random(in: 1000000000..<10000000000)
              
              try await KeyChainManager.shared.create(account: .userId, data: String(userID))
              try await KeyChainManager.shared.create(account: .platform, data: "apple")
              
              try await memberInfo.registerKakaoUser(
                memberId: userID,
                newUserInfo: .init(
                  name: name,
                  positionType: selectedPosition,
                  teamType: .none,
                  teamNumber: 0
                )
              )
              let member = try await memberInfo.getMemberInfo(memberId: userID)
              await send(.pushHomeTab(member))
            }
          } else {
            await send(.incorrectCode)
          }
        } catch: { error, send in
          print(error)
        }
      case .incorrectCode:
        state.isIncorrectCode = true
        state.isFocus = false
        return .none
      default:
        return .none
      }
    }
  }
}
