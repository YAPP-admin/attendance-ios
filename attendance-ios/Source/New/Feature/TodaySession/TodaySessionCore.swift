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
        var session: Session?
        var isCompleteAttendance: Bool = false
    }
    
    enum Action: Equatable {
        case showSetting
        case onAppear
        case setSession(Session?)
    }
    
    @Dependency(\.sessionInfo.sessionInfo) var sessionInfo
    
    var body: some ReducerProtocolOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    let session = try await sessionInfo.todaySession()
                    await send(.setSession(session))
                } catch: { error, send in
                    
                }
            case let .setSession(currentSession):
                state.session = currentSession
                return .none
            default:
                return .none
            }
        }
    }
}
