//
//  KeychainError.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/16.
//

import Foundation

enum KeyChainError: LocalizedError {
    case unhandledError(status: OSStatus)
    case itemNotFound
    
    var errorDescription: String? {
        switch self {
        case .unhandledError(let status):
            return "KeyChain unhandle Error: \(status)"
        case .itemNotFound:
            return "KeyChain item Not Found"
        }
    }
}
