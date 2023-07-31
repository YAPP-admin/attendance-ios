//
//  MemberInfo.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/16.
//

import Foundation

import ComposableArchitecture

final class MemberInfoUseCase {
    
    @Dependency(\.firebase.firebaseWorker) var firebaseWorker
    
    init() { }
    
    func getMemberInfo(memberId: Int) async throws -> Member? {
        return try await withCheckedThrowingContinuation { continuation in
            firebaseWorker.getMemberDocumentData(memberId: memberId) { result in
                switch result {
                case let .success(memberInfo):
                    continuation.resume(returning: memberInfo)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func registerKakaoUser(memberId: Int, newUserInfo: FirebaseNewMember) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            firebaseWorker.registerKakaoUserInfo(id: memberId, newUser: newUserInfo) { result in
                switch result {
                case .success:
                    continuation.resume(returning: ())
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
