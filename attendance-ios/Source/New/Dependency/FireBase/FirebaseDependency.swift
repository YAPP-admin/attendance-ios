//
//  FirebaseDependency.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/16.
//

import Foundation

import ComposableArchitecture

struct FirebaseDependency: Sendable {
    var registerKakaoUserInfo: @Sendable (_ id: Int, _ newUser: FirebaseNewMember) async throws -> Void
    var registerAppleUserInfo: @Sendable (_ id: String, _ newUser: FirebaseNewMember) async throws -> Void
    var changeMemberDocumentName: @Sendable (_ appleId: String, _ kakaoId: String) async throws -> Void
    var deleteKakaoTalkUserInfo: @Sendable () async throws -> Void
    var deleteDocument: @Sendable (_ id: String) async throws -> Void
    var deleteMemberDocument: @Sendable (_ memberId: Int) async throws -> Void
    var updateMemberAttendances: @Sendable (_ memberId: Int, _ attendances: [Attendance]) async throws -> Void
    var updateMemberInfo: @Sendable (_ memberId: Int, _ team: Team) async throws -> Void
    var getMember: @Sendable (_ memberId: Int) async throws -> Void
    var getMemberDocumentId: @Sendable (_ memberId: Int) async throws -> Void
    var getMemberDocumentData: @Sendable (_ memberId: Int) async throws -> Void
    var getAllMembers: @Sendable () async throws -> [Member]
    var getMemberDocumentIdList: @Sendable () async throws -> [String]
    var checkIsRegisteredUser: @Sendable (_ id: String) async throws -> Bool
}

extension FirebaseDependency: DependencyKey {
    
  static let liveValue = Self(
    registerKakaoUserInfo: { id, newUser in
        return try await withCheckedThrowingContinuation { continuation in
            FirebaseWorker.shared.registerKakaoUserInfo(id: id, newUser: newUser) { result in
                switch result {
                case .success:
                    break
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }
    },
    registerAppleUserInfo: { id, newUser in
        return try await withCheckedThrowingContinuation { continuation in
            FirebaseWorker.shared.registerAppleUserInfo(id: id, newUser: newUser) { result in
                switch result {
                case .success:
                    break
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }
    },
    changeMemberDocumentName: { appleId, kakaoId in
        return try await withCheckedThrowingContinuation { continuation in
            FirebaseWorker.shared.changeMemberDocumentName(appleId, to: kakaoId) { result in
                switch result {
                case .success:
                    break
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }
    },
    deleteKakaoTalkUserInfo: {
        FirebaseWorker.shared.deleteKakaoTalkUserInfo()
    },
    deleteDocument: { id in
        FirebaseWorker.shared.deleteDocument(id: id)
    },
    deleteMemberDocument: { memberId in
        return try await withCheckedThrowingContinuation { continuation in
            FirebaseWorker.shared.deleteDocument(memberId: memberId) { result in
                switch result {
                case .success:
                    break
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }
    },
    updateMemberAttendances: { memberId, attendances in
        FirebaseWorker.shared.updateMemberAttendances(memberId: memberId, attendances: attendances)
    },
    updateMemberInfo: { memberId, team in
        return try await withCheckedThrowingContinuation { continuation in
            FirebaseWorker.shared.updateMemberInfo(memberId: memberId, team: team) {
                
            }
        }
    },
    getMember: { memberId in
        return try await withCheckedThrowingContinuation { continuation in
            FirebaseWorker.shared.getMember(memberId: memberId) { result in
                switch result {
                case .success:
                    break
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }
    },
    getMemberDocumentId: { memberId in
        return try await withCheckedThrowingContinuation { continuation in
            FirebaseWorker.shared.getMemberDocumentId(memberId: memberId) { result in
                switch result {
                case .success:
                    break
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }
    },
    getMemberDocumentData: { memberId in
        return try await withCheckedThrowingContinuation { continuation in
            FirebaseWorker.shared.getMemberDocumentData(memberId: memberId) { result in
                switch result {
                case .success:
                    break
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }
    },
    getAllMembers: {
        return try await withCheckedThrowingContinuation { continuation in
            FirebaseWorker.shared.getAllMembers { result in
                switch result {
                case let .success(members):
                    continuation.resume(returning: members)
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }
    },
    getMemberDocumentIdList: {
        return try await withCheckedThrowingContinuation { continuation in
            FirebaseWorker.shared.getMemberDocumentIdList { result in
                switch result {
                case let .success(idList):
                    continuation.resume(returning: idList)
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }
    },
    checkIsRegisteredUser: { id in
        return try await withCheckedThrowingContinuation { continuation in
            FirebaseWorker.shared.checkIsRegisteredUser(id: id) { result in
                continuation.resume(returning: result)
            }
        }
    }
    
  )

  static let testValue = Self(
    registerKakaoUserInfo: unimplemented("FirebaseDependency.registerKakaoUserInfo"),
    registerAppleUserInfo: unimplemented("FirebaseDependency.registerAppleUserInfo"),
    changeMemberDocumentName: unimplemented("FirebaseDependency.changeMemberDocumentName"),
    deleteKakaoTalkUserInfo: unimplemented("FirebaseDependency.deleteKakaoTalkUserInfo"),
    deleteDocument: unimplemented("FirebaseDependency.deleteDocument"),
    deleteMemberDocument: unimplemented("FirebaseDependency.deleteMemberDocument"),
    updateMemberAttendances: unimplemented("FirebaseDependency.updateMemberAttendances"),
    updateMemberInfo: unimplemented("FirebaseDependency.updateMemberInfo"),
    getMember: unimplemented("FirebaseDependency.getMember"),
    getMemberDocumentId: unimplemented("FirebaseDependency.getMemberDocumentId"),
    getMemberDocumentData: unimplemented("FirebaseDependency.getMemberDocumentData"),
    getAllMembers: unimplemented("FirebaseDependency.getAllMembers"),
    getMemberDocumentIdList: unimplemented("FirebaseDependency.getMemberDocumentIdList"),
    checkIsRegisteredUser: unimplemented("FirebaseDependency.checkIsRegisteredUser")
  )
}

extension DependencyValues {
  var firebase: FirebaseDependency {
    get { self[FirebaseDependency.self] }
    set { self[FirebaseDependency.self] = newValue }
  }
}
