//
//  KeychainAccount.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/16.
//

import Foundation

enum KeyChainAccount {
    case userId
    
    var description: String {
        return String(describing: self)
    }
    
    var keyChainClass: CFString {
        switch self {
        case .userId:
            return kSecPolicyName
        }
    }
}
