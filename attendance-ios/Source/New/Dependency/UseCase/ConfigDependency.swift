//
//  ConfigDependency.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/10/25.
//

import Foundation

import ComposableArchitecture

struct ConfigDependency {
    var remoteConfig: ConfigUseCase
}

extension ConfigDependency: DependencyKey {

  static let liveValue = Self(
    remoteConfig: ConfigUseCase()
  )

  static let testValue = Self(
    remoteConfig: unimplemented("SessionInfoDependency.sessionInfo")
  )
}

extension DependencyValues {
  var config: ConfigDependency {
    get { self[ConfigDependency.self] }
    set { self[ConfigDependency.self] = newValue }
  }
}
