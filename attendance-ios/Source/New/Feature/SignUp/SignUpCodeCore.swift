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
        var isEnabledNextButton: Bool = true
        var isFocus: Bool = false
        var code: String = ""
        
        var selectedPosition: Position
        var name: String
        
        init(name: String, selectedPosition: Position) {
            self.name = name
            self.selectedPosition = selectedPosition
        }
    }
    
    enum Action: Equatable {
        case focus(Bool)
    }
    
    var body: some ReducerProtocolOf<Self> {
        Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
    }
}
