//
//  SignUpPositionCore.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/16.
//

import Foundation

import ComposableArchitecture

struct SignUpPosition: ReducerProtocol {
    
    struct State: Equatable {
        var isEnabledNextButton: Bool = false
        var selectedPosition: Position?
        var name: String
        
        init(name: String) {
            self.name = name
        }
    }
    
    enum Action: Equatable {
        case select(Position)
    }
    
    var body: some ReducerProtocolOf<Self> {
        Reduce { state, action in
            switch action {
            case let .select(position):
                state.selectedPosition = position
                state.isEnabledNextButton = true
                return .none
            default:
                return .none
            }
        }
    }
}
