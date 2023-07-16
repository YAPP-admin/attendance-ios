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
    }
    
    enum Action: Equatable {
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
