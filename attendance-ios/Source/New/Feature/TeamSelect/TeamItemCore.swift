//
//  TeamItemCore.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/10/23.
//

import Foundation

import ComposableArchitecture

public struct TeamItem: ReducerProtocol {
  public struct State: Identifiable, Equatable {
    public var id: UUID
    
    /// View
    var team: Team
    var isSelected: Bool = false
    
    init(
      team: Team
    ) {
      self.id = UUID()
      self.team = team
    }
  }
  
  public enum Action: Equatable {
    case tapped
  }
  
  public init() {}
  
  public var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      default:
        return .none
      }
    }
  }
}
