//
//  RemoteConfigDependency.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/16.
//

import Foundation

import Foundation

import ComposableArchitecture

struct RemoteConfigDependency {
    var remoteConfig: ConfigWorker
//    var yappConfig: @Sendable () async throws -> YappConfig
//    var selectTeams: @Sendable () async throws -> [Team]
//    var maginotlineTime: @Sendable () async throws -> String
//    var qrPassword: @Sendable () async throws -> String
//    var shouldShowGuestButton: @Sendable () async throws -> Bool
}

extension RemoteConfigDependency: DependencyKey {
    
  static let liveValue = Self(
    remoteConfig: ConfigWorker.shared
  )

  static let testValue = Self(
    remoteConfig: unimplemented("RemoteConfigDependency.sessionList")
  )
}

extension DependencyValues {
  var remoteConfig: RemoteConfigDependency {
    get { self[RemoteConfigDependency.self] }
    set { self[RemoteConfigDependency.self] = newValue }
  }
}
