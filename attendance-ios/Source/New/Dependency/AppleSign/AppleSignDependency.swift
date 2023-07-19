//
//  AppleSignDependency.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/16.
//

import Foundation

import ComposableArchitecture

struct AppleSignDependency: Sendable {
    var login: @Sendable () async throws -> String
}

extension AppleSignDependency: DependencyKey {
    
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
  var appleSign: AppleSignDependency {
    get { self[AppleSignDependency.self] }
    set { self[AppleSignDependency.self] = newValue }
  }
}


