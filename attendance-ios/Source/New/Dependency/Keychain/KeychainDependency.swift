//
//  KeychainDependency.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/08/01.
//

import Foundation

import ComposableArchitecture

struct KeychainDependency: Sendable {
    var login: @Sendable () async throws -> String
}

extension KeychainDependency: DependencyKey {
    
  static let liveValue = Self(
    login: {
        try await DefaultAppleAuthRespository.shared.loginWithApple()
    }
  )

  static let testValue = Self(
    login: unimplemented("AppleSignDependency.login")
  )
}

extension DependencyValues {
  var keychain: KeychainDependency {
    get { self[KeychainDependency.self] }
    set { self[KeychainDependency.self] = newValue }
  }
}

