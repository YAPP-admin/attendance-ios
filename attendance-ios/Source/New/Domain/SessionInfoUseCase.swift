//
//  SessionInfoUseCase.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/16.
//

import Foundation

import ComposableArchitecture

final class SessionInfoUseCase {
  
  @Dependency(\.remoteConfig.remoteConfig) var remoteConfig
  
  init() { }
  
  func todaySession() async throws -> Session? {
    return try await withCheckedThrowingContinuation { continuation in
      guard let nowDate = Date().startDate() else {
        return continuation.resume(returning: nil)
      }
      remoteConfig.decodeSessionList(completion: { result in
        switch result {
        case let .success(sessionList):
          let sessions = sessionList.filter { nowDate.isFuture(than: $0.date.date()) }
          continuation.resume(returning: sessions.first)
        case let .failure(error):
          continuation.resume(throwing: error)
        }
      })
    }
  }
  
  func getSessionList() async throws -> [Session] {
    return try await withCheckedThrowingContinuation { continuation in
      remoteConfig.decodeSessionList(completion: { result in
        switch result {
        case let .success(sessions):
          continuation.resume(returning: sessions)
        case let .failure(error):
          continuation.resume(throwing: error)
        }
      })
    }
  }
}
