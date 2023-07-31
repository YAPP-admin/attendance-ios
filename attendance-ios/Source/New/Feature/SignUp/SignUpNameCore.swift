//
//  LoginReducer.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/08.
//

import Foundation

import ComposableArchitecture

struct SignUpName: ReducerProtocol {
    
    struct State: Equatable {
        var isEnabledNextButton: Bool = false
        var isFocus: Bool = false
        
        @BindingState var textName: String
        @BindingState var showingCancelPopup: Bool = false
        
        init(userName: String) {
            self.textName = userName
        }
    }
    
    enum Action: Equatable, BindableAction {
        case focus(Bool)
        case binding(BindingAction<State>)
        case showCancelPopup
        case dismissCancelPopup
        case pop
    }
    
    var body: some ReducerProtocolOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case let .focus(isFocus):
                state.isFocus = isFocus
                return .none
            case .binding(\.$textName):
                if state.textName != "" {
                    state.isEnabledNextButton = true
                }
                return .none
            case .showCancelPopup:
                state.showingCancelPopup = true
                state.isFocus = false
                return .none
            case .dismissCancelPopup:
                state.showingCancelPopup = false
                return .none
            case .pop:
                return .run { action in
                    try await KeyChainManager.shared.delete(account: .userId)
                } catch: { error, send in
                    print(error)
                }
            default:
                return .none
            }
        }
        
    }
}
