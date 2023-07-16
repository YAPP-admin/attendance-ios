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
    var login: @Sendable () async throws -> String
    var logout: @Sendable () async throws -> Void
    var userId: @Sendable () async throws -> String
}

extension KakaoSignDependency: DependencyKey {
  static let liveValue = Self(
    login: {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.main.async {
                if UserApi.isKakaoTalkLoginAvailable() {
                    UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                        guard let authToken = oauthToken else { return }
                        if let error = error {
                            continuation.resume(throwing: error)
                        } else {
                            continuation.resume(returning: authToken.accessToken)
                        }
                    }
                } else {
                    UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                        guard let authToken = oauthToken else { return }
                        
                        if let error = error {
                            continuation.resume(throwing: error)
                        } else {
                            continuation.resume(returning: authToken.accessToken)
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
    userId: {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.me { user, error in
                if let error = error {
                    continuation.resume(throwing: error)
                }
                else {
                    guard let userId = user?.id else {
                        return
                    }
                    
                    continuation.resume(returning: String(userId))
                }
            }
        }
    }
  )

  static let testValue = Self(
    login: unimplemented("KakaoSignDependency.login"),
    logout: unimplemented("KakaoSignDependency.logout"),
    userId: unimplemented("KakaoSignDependency.userId")
  )
}

extension DependencyValues {
  var kakaoSign: KakaoSignDependency {
    get { self[KakaoSignDependency.self] }
    set { self[KakaoSignDependency.self] = newValue }
  }
}
