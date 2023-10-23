//
//  SettingCore.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/16.
//

import Foundation

import ComposableArchitecture

struct Setting: ReducerProtocol {
  
  struct State: Equatable {
    var member: Member?
    var yappGeneration: Int = 23
    var selectTeam: Team?
    var appVersion: String {
      return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }
    
    @PresentationState var destination: Destination.State?
    
    init(member: Member?) {
      self.member = member
      
      if let team = member?.team,
         team.type != .none {
        self.selectTeam = team
      }
    }
  }
  
  enum Action: Equatable {
    case onAppear
    case setYappGeneration(Int)
    case tappedTeamSelect
    case getMemberInfo
    case setMemberInfo(Member?)
    
    case destination(PresentationAction<Destination.Action>)
  }
  
  public struct Destination: ReducerProtocol {
    public enum State: Equatable {
      case teamSelect(TeamSelect.State)
      case alert(AlertState<Action.Alert>)
    }
    
    public enum Action: Equatable {
      case teamSelect(TeamSelect.Action)
      case alert(Alert)
      
      public enum Alert {
        case cancel
      }
    }
    
    public var body: some ReducerProtocolOf<Self> {
      Scope(state: /State.teamSelect, action: /Action.teamSelect) {
        TeamSelect()
      }
    }
  }
  
  @Dependency(\.sessionInfo.sessionInfo) var sessionInfo
  @Dependency(\.memberInfo.memberInfo) var memberInfo
  
  var body: some ReducerProtocolOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { send in
          let yappGeneration = try await sessionInfo.getYAPPGeneration()
          
          await send(.setYappGeneration(yappGeneration))
        }
      case let .setYappGeneration(data):
        state.yappGeneration = data
        return .none
      case .tappedTeamSelect:
        state.destination = .teamSelect(TeamSelect.State(member: state.member))
        
        return .none
      case .destination(.presented(.teamSelect(.dismiss))):
        state.destination = nil
        return .none
      case let .destination(.presented(.teamSelect(.selectedTeam(team)))):
        state.destination = nil
        state.selectTeam = team
        return .send(.getMemberInfo)
      case .getMemberInfo:
        if let memberId = state.member?.id {
          return .run { send in
            let member = try await memberInfo.getMemberInfo(memberId: memberId)
            await send(.setMemberInfo(member))
          }
        }
        return .none
      case let .setMemberInfo(member):
        state.member = member
        
        return .none
      default:
        return .none
      }
    }
    .ifLet(\.$destination, action: /Action.destination) {
      Destination()
    }
    
  }
}
