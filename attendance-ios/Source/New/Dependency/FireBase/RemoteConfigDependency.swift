//
//  RemoteConfigDependency.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/16.
//

import Foundation

import Foundation

import ComposableArchitecture

struct RemoteConfigDependency: Sendable {
    var login: @Sendable () async throws -> SignInUserModel
}

extension RemoteConfigDependency: DependencyKey {
    
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
  var remoteConfig: RemoteConfigDependency {
    get { self[RemoteConfigDependency.self] }
    set { self[RemoteConfigDependency.self] = newValue }
  }
}
