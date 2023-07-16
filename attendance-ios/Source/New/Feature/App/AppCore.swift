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
        var onboarding = Onboarding.State()
    }
    
    enum Action {
        case path(StackAction<Path.State, Path.Action>)
        
        case onboarding(Onboarding.Action)
    }
    
    var body: some ReducerProtocolOf<Self> {
        
        Scope(state: \.onboarding, action: /Action.onboarding) {
            Onboarding()
        }
        
        Reduce<State, Action> { state, action in
            switch action {
            case let .path(.element(id: id, action: .signUpName(.pop))):
                guard case .some(.signUpName) = state.path[id: id]
                else { return .none }
                
                state.path.pop(from: id)
                return .none
            case let .onboarding(.pushSingUpName(userName)):
                
                state.path.append(App.Path.State.signUpName(SignUpName.State(userName: userName)))
                
                return .none
            default:
                return .none
            }
        }
        .forEach(\.path, action: /Action.path) {
            Path()
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
        }
        
        enum Action {
            case signUpName(SignUpName.Action)
            case signUpPosition(SignUpPosition.Action)
            case signUpCode(SignUpCode.Action)
            
            case homeTab(HomeTab.Action)
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
        }
    }
}


