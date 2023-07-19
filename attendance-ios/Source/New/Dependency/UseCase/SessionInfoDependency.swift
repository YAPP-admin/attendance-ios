//
//  SessionInfoUseCase.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/16.
//

import Foundation

import ComposableArchitecture

struct SessionInfoDependency {
    var sessionInfo: SessionInfoUseCase
}

extension SessionInfoDependency: DependencyKey {

  static let liveValue = Self(
    sessionInfo: SessionInfoUseCase()
  )

  static let testValue = Self(
    sessionInfo: unimplemented("SessionInfoDependency.sessionInfo")
  )
}

extension DependencyValues {
  var sessionInfo: SessionInfoDependency {
    get { self[SessionInfoDependency.self] }
    set { self[SessionInfoDependency.self] = newValue }
  }
}

