//
//  FirebaseDependency.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/16.
//

import Foundation

import ComposableArchitecture

struct FirebaseDependency {
    var firebaseWorker: FirebaseWorker
}

extension FirebaseDependency: DependencyKey {
    
  static let liveValue = Self(
    firebaseWorker: FirebaseWorker.shared
    
  )

  static let testValue = Self(
    firebaseWorker: unimplemented("FirebaseDependency.firebaseWorker")
  )
}

extension DependencyValues {
  var firebase: FirebaseDependency {
    get { self[FirebaseDependency.self] }
    set { self[FirebaseDependency.self] = newValue }
  }
}
