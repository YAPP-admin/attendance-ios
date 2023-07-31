//
//  kakaoSignDependency.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/16.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon

import ComposableArchitecture

struct KakaoSignDependency: Sendable {
    var login: @Sendable () async throws -> Void
    var logout: @Sendable () async throws -> Void
    var getUserId: @Sendable () async throws -> String
    var saveUserId: @Sendable () async throws -> Void
}

extension KakaoSignDependency: DependencyKey {
  static let liveValue = Self(
    login: {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.main.async {
                if UserApi.isKakaoTalkLoginAvailable() {
                    UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                        guard let authToken = oauthToken else { return }
                        
                        continuation.resume(returning: ())
                        if let error = error {
                            continuation.resume(throwing: error)
                        }
                    }
                } else {
                    UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                        guard let authToken = oauthToken else { return }
                        
                        continuation.resume(returning: ())
                        if let error = error {
                            continuation.resume(throwing: error)
                        }
                    }
                }
            }
        }
    },
    logout: {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.logout { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    },
    getUserId: {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.me { user, error in
                Task {
                    guard let userId = user?.id else {
                        continuation.resume(throwing: YPError.kakaoAuth)
                        return
                    }
                    
                    continuation.resume(returning: String(userId))
                }
            }
        }
    },
    saveUserId: {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.me { user, error in
                Task {
                    guard let userId = user?.id else {
                        continuation.resume(throwing: YPError.kakaoAuth)
                        return
                    }
                    
                    do {
                        try await KeyChainManager.shared.create(account: .userId, data: String(userId))
                        continuation.resume(returning: ())
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
  )

  static let testValue = Self(
    login: unimplemented("KakaoSignDependency.login"),
    logout: unimplemented("KakaoSignDependency.logout"),
    getUserId: unimplemented("KakaoSignDependency.getUserId"),
    saveUserId: unimplemented("KakaoSignDependency.saveUserId")
  )
}

extension DependencyValues {
  var kakaoSign: KakaoSignDependency {
    get { self[KakaoSignDependency.self] }
    set { self[KakaoSignDependency.self] = newValue }
  }
}
