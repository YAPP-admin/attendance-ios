//
//  OnboardingCore.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/08.
//

import Foundation

import ComposableArchitecture

struct Onboarding: ReducerProtocol {
    
    struct State: Equatable {
        var isLaunching: Bool = false
    }
    
    enum Action {
        case launch
        case kakaoSignButtonTapped
        case appleSignButtonTapped
        
        case pushSingUpName(String)
    }
    
    @Dependency(\.kakaoSign) var kakaoSign
    @Dependency(\.appleSign) var appleSign
    
    var body: some ReducerProtocolOf<Self> {
        Reduce { state, action in
            switch action {
            case .launch:
                state.isLaunching = true
                return .none
            case .kakaoSignButtonTapped:
                return .run { send in
                    try await kakaoSign.login()
                    try await kakaoSign.saveUserId()
                    
                    await send(.pushSingUpName(""))
                } catch: { error, send in
                    //
                }
            case .appleSignButtonTapped:
                return .run { send in
                    let name = try await appleSign.login()
                    await send(.pushSingUpName(name))
                } catch: { error, send in
                    //
                }
            default:
                return .none
            }
        }
    }
}
