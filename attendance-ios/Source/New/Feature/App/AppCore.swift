//
//  App.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/13.
//

import Foundation

import ComposableArchitecture

struct App: ReducerProtocol {
  
  struct State: Equatable {
    var path = StackState<Path.State>()
    var appLaunch: AppLaunch.State?
  }
  
  enum Action {
    case path(StackAction<Path.State, Path.Action>)
    case onAppear
    case launchOnboarding
    case launchTodaySession(Member?)
    
    case appLaunch(AppLaunch.Action)
  }
  
  @Dependency(\.memberInfo) var memberInfo
  
  var body: some ReducerProtocolOf<Self> {
    
    Reduce<State, Action> { state, action in
      switch action {
      case .onAppear:
        
        return .run { send in
          do {
            let userId = try await KeyChainManager.shared.read(account: .userId)
            let member = try await memberInfo.memberInfo.getMemberInfo(memberId: Int(userId) ?? 0)
            
            await send(.launchTodaySession(member))
          } catch {
            await send(.launchOnboarding)
          }
        }
        
      case .launchOnboarding:
        
        state.appLaunch = .onboarding(Onboarding.State())
        
        return .none
        
      case let .launchTodaySession(member):
      
        state.appLaunch = .tab(HomeTab.State(member: member, selectTab: .todaySession))
        
        return .none
        
//      case let .path(.element(id: id, action: .signUpName(.pop))):
//        guard case .some(.signUpName) = state.path[id: id]
//        else { return .none }
//
//        state.path.pop(from: id)
//
//        return .none
        
//      case let .path(.popFrom(id: id)):
//        guard case .some(.signUpName) = state.path[id: id]
//        else { return .none }
//        
//        return .send(.path(.element(id: id, action: .signUpName(.showCancelPopup))))
        
      case let .appLaunch(.onboarding(.pushSingUpName(userName))):
        
        state.path.append(App.Path.State.signUpName(SignUpName.State(userName: userName)))
        
        return .none
        
      case let .appLaunch(.onboarding(.pushHomeScene(member))):
        
        state.path.append(App.Path.State.homeTab(.init(member: member, selectTab: .todaySession)))
        
        return .none
        
      case let .path(.element(id: _, action: .signUpCode(.pushHomeTab(member)))):
        
        state.path.append(App.Path.State.homeTab(.init(member: member, selectTab: .todaySession)))
        
        return .none
        
      case let .path(.element(id: _, action: .homeTab(.tappedSettingButton(member)))):
        
        state.path.append(Path.State.setting(Setting.State(member: member)))
        
        return .none
        
      case let .appLaunch(.tab(.tappedSettingButton(member))):
        
        state.path.append(Path.State.setting(Setting.State(member: member)))
        
        return .none
        
      case let .path(.element(id: id, action: .setting(.setMemberInfo(member)))):
        
        return .run { send in
          await send(.appLaunch(.tab(.setMember(member))))
          await send(.path(.element(id: id, action: .homeTab(.setMember(member)))))
        }
      case .path(.element(id: _, action: .setting(.logout))):
        
        state.path.removeAll()
        state.appLaunch = .onboarding(Onboarding.State(isFirstLaunched: false))
        
        return .none
        
      case .path(.element(id: _, action: .setting(.deleteUser))):
        
        state.path.removeAll()
        state.appLaunch = .onboarding(Onboarding.State(isFirstLaunched: false))
        
        return .none
      default:
        return .none
      }
    }
    .forEach(\.path, action: /Action.path) {
      Path()
    }
    .ifLet(\.appLaunch, action: /Action.appLaunch) {
      AppLaunch()
    }
  }
}

extension App {
  struct Path: ReducerProtocol {
    enum State: Equatable {
      case signUpName(SignUpName.State)
      case signUpPosition(SignUpPosition.State)
      case signUpCode(SignUpCode.State)
      
      case homeTab(HomeTab.State)
      
      case scoreInfo(ScoreInfo.State)
      
      case setting(Setting.State)
    }
    
    enum Action {
      case signUpName(SignUpName.Action)
      case signUpPosition(SignUpPosition.Action)
      case signUpCode(SignUpCode.Action)
      
      case homeTab(HomeTab.Action)
      
      case scoreInfo(ScoreInfo.Action)
      
      case setting(Setting.Action)
    }
    
    var body: some ReducerProtocolOf<Self> {
      Scope(state: /State.signUpName, action: /Action.signUpName) {
        SignUpName()
      }
      
      Scope(state: /State.signUpPosition, action: /Action.signUpPosition) {
        SignUpPosition()
      }
      
      Scope(state: /State.signUpCode, action: /Action.signUpCode) {
        SignUpCode()
      }
      
      Scope(state: /State.homeTab, action: /Action.homeTab) {
        HomeTab()
      }
      
      Scope(state: /State.scoreInfo, action: /Action.scoreInfo) {
          EmptyReducer()
      }
      
      Scope(state: /State.setting, action: /Action.setting) {
        Setting()
      }
    }
  }
}


