//
//  KeychainManager.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/16.
//

import Foundation

class KeyChainManager {
    
    static let shared = KeyChainManager()
    private let service = Bundle.main.bundleIdentifier
    
    private init() { }
    
    func create(account: KeyChainAccount, data: String) async throws {
        let query = [kSecClass: account.keyChainClass,
                     kSecAttrService: service,
                     kSecAttrAccount: account.description,
                     kSecValueData: (data as AnyObject).data(using: String.Encoding.utf8.rawValue) ] as CFDictionary
        
        SecItemDelete(query)
        
        let status = SecItemAdd(query, nil)
        
        if status == errSecSuccess {
            print("add success")
        } else if status == errSecDuplicateItem {
            print("keychain에 Item이 이미 있음")
        } else {
            throw KeyChainError.unhandledError(status: status)
        }
    }
    
    func read(account: KeyChainAccount) async throws -> String {
        let query = [kSecClass: account.keyChainClass,
                     kSecAttrService: service,
                     kSecAttrAccount: account.description,
                     kSecReturnData: true] as CFDictionary
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)
        
        guard status != errSecItemNotFound else {
            throw KeyChainError.itemNotFound
        }
        
        if status == errSecSuccess,
           let item = dataTypeRef as? Data,
           let data = String(data: item, encoding: String.Encoding.utf8) {
            return data
        } else {
            throw KeyChainError.unhandledError(status: status)
        }
    }
    
    func delete(account: KeyChainAccount) async throws {
        let query = [kSecClass: account.keyChainClass,
                     kSecAttrService: service,
                     kSecAttrAccount: account.description] as CFDictionary
        
        let status = SecItemDelete(query)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeyChainError.unhandledError(status: status)
        }
    }
}
