//
//  TeamSelectCore.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/10/23.
//

import Foundation

import ComposableArchitecture

struct TeamSelect: ReducerProtocol {
  
  struct State: Equatable {
    var selectedTeamType: TeamType?
    var selectedTeamNumber: Int?
    var isEnabledNextButton: Bool {
      selectedTeamType != nil && selectedTeamNumber != nil
    }
    
    var member: Member?
    
    init(member: Member? = nil) {
      self.member = member
    }
  }
  
  enum Action: Equatable {
    case onAppear
    case dismiss
    case selectTeamType(TeamType)
    case selectTeamNumber(Int)
    case tappedConfirmButton
    case selectedTeam(Team)
  }
  
  @Dependency(\.sessionInfo.sessionInfo) var sessionInfo
  @Dependency(\.memberInfo.memberInfo) var memberInfo
  
  var body: some ReducerProtocolOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { send in
//          let teamList = try await sessionInfo.getTeamList()
        }
      case let .selectTeamType(teamType):
        state.selectedTeamType = teamType
        return .none
      case let .selectTeamNumber(number):
        state.selectedTeamNumber  = number
        return .none
      case .tappedConfirmButton:
        if let selectedTeamType = state.selectedTeamType,
           let selectedTeamNumber = state.selectedTeamNumber,
           let member = state.member {
          let team = Team(type: selectedTeamType, number: selectedTeamNumber)
          return .run { send in
            try await memberInfo.updateMemberInfo(memberId: member.id, team: team)
            await send(.selectedTeam(team))
          }
        }
        return .none
      default:
        return .none
      }
    }
    
  }
}
