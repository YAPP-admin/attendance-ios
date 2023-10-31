//
//  ConfigUseCase.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/10/25.
//

import Foundation

import ComposableArchitecture

final class ConfigUseCase {
  
  @Dependency(\.remoteConfig.remoteConfig) var remoteConfig
  
  init() { }
  
  func getSessionPassword() async throws -> String {
    return try await withCheckedThrowingContinuation { continuation in
      remoteConfig.decodeSessionPassword { result in
        switch result {
        case let .success(code):
          continuation.resume(returning: code)
        case let .failure(error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
  
  func getSignUpPassword() async throws -> String {
    return try await withCheckedThrowingContinuation { continuation in
      remoteConfig.decodeSignUpPassword { result in
        switch result {
        case let .success(code):
          continuation.resume(returning: code)
        case let .failure(error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
  
  func shouldShowGuestButton() async throws -> Bool {
    return try await withCheckedThrowingContinuation { continuation in
      remoteConfig.decodeShouldShowGuestButton { result in
        switch result {
        case let .success(isShow):
          continuation.resume(returning: isShow)
        case let .failure(error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
}
