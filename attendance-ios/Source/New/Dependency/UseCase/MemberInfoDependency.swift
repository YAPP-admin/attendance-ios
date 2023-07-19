//
//  MemberInfoUseCase.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/16.
//

import Foundation

import ComposableArchitecture

struct MemberInfoDependency {
    var memberInfo: MemberInfoUseCase
}

extension MemberInfoDependency: DependencyKey {

  static let liveValue = Self(
    memberInfo: MemberInfoUseCase()
  )

  static let testValue = Self(
    memberInfo: unimplemented("SessionInfoDependency.memberInfo")
  )
}

extension DependencyValues {
  var memberInfo: MemberInfoDependency {
    get { self[MemberInfoDependency.self] }
    set { self[MemberInfoDependency.self] = newValue }
  }
}
