//
//  TodaySessionCore.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/12.
//

import Foundation

import ComposableArchitecture

struct TodaySession: ReducerProtocol {
    
    struct State: Equatable {
        
    }
    
    enum Action: Equatable {
        case showSetting
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
