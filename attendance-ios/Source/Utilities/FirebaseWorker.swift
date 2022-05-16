//
//  FirebaseWorker.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/04/14.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseRemoteConfig
import KakaoSDKUser
import UIKit

final class FirebaseWorker {
    private let memberCollectionRef = Firestore.firestore().collection("member")
}

// MARK: - Register
struct FirebaseNewMember {
    let name: String
    let positionType: PositionType
    let teamType: TeamType
    let teamNumber: Int
}

extension FirebaseWorker {

    func registerKakaoUserInfo(id: Int, newUser: FirebaseNewMember, completion: @escaping (Result<Void, Error>) -> Void) {
        memberCollectionRef.document("\(id)").setData([
            "id": id,
            "name": newUser.name,
            "position": newUser.positionType.rawValue,
            "team": ["number": newUser.teamNumber,
                     "type": newUser.teamType.rawValue],
            "attendances": self.makeEmptyAttendances()
        ]) { error in
            guard let error = error else {
                completion(.success(()))
                return
            }
            completion(.failure(error))
        }
    }

    func registerAppleUserInfo(id: String, newUser: FirebaseNewMember, completion: @escaping (Result<Void, Error>) -> Void) {
        memberCollectionRef.document("\(id)").setData([
            "id": Int.random(in: 1000000000..<10000000000),
            "name": newUser.name,
            "position": newUser.positionType.rawValue,
            "team": ["number": newUser.teamNumber,
                     "type": newUser.teamType.rawValue],
            "attendances": self.makeEmptyAttendances()
        ]) { error in
            guard let error = error else {
                completion(.success(()))
                return
            }
            completion(.failure(error))
        }
    }

    private func makeEmptyAttendances() -> [[String: Any]] {
        var attendances: [[String: Any]] = []
        let sessionCount = 20
        for id in 0..<sessionCount {
            let empty: [String: Any] = ["sessionId": id,
                                        "type": ["text": "결석", "point": -20]]
            attendances.append(empty)
        }
        return attendances
    }

    /// 문서 이름을 애플 아이디에서 카카오톡 아이디로 변경합니다.
    func changeMemberDocumentName(_ appleId: String, to kakaoId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let docRef = memberCollectionRef.document(appleId)
        docRef.getDocument { [weak self] snapshot, error in
            if let error = error {
                completion(.failure(error))
            }
            guard let self = self, let newId = Int(kakaoId), let member = try? snapshot?.data(as: Member.self) else { return }

            let newUser = FirebaseNewMember(name: member.name, positionType: member.position, teamType: member.team.type, teamNumber: member.team.number)
            self.registerKakaoUserInfo(id: newId, newUser: newUser) { result in
                switch result {
                case .success:
                    self.deleteDocument(id: appleId)
                    completion(.success(()))
                case .failure: ()
                }
            }
        }
    }

}

extension FirebaseWorker {

    /// 카카오톡으로 로그인한 유저의 문서를 삭제합니다.
    func deleteKakaoTalkUserInfo() {
        UserApi.shared.me { [weak self] user, _ in
            guard let self = self, let userId = user?.id else { return }
            self.deleteDocument(id: String(userId))
        }
    }

    /// 문서를 삭제합니다.
    func deleteDocument(id: String) {
        memberCollectionRef.document(id).delete()
    }

}

extension FirebaseWorker {

    func updateMemberAttendances(memberId: Int, attendances: [Attendance]) {
        memberCollectionRef.getDocuments { snapshot, error in
            guard error == nil, let documents = snapshot?.documents else { return }
            for document in documents {
                guard let member = try? document.data(as: Member.self), member.id == memberId else { continue }
                let ref = self.memberCollectionRef.document(document.documentID)
                ref.updateData([
                    "id": member.id,
                    "name": member.name,
                    "position": member.position.rawValue,
                    "team": ["number": member.team.number,
                             "type": member.team.type.rawValue],
                    "attendances": member.attendances.decode()
                ])
            }
        }
    }

    func getMember(memberId: Int, completion: @escaping (Result<Member, Error>) -> Void) {
        memberCollectionRef.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            }
            guard let documents = snapshot?.documents else { return }
            for document in documents {
                guard let member = try? document.data(as: Member.self) else { continue }
                if member.id == memberId {
                    completion(.success(member))
                }
            }
        }
    }

    func getMemberDocumentId(memberId: Int, completion: @escaping (Result<String, Error>) -> Void) {
        memberCollectionRef.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            }
            guard let documents = snapshot?.documents else { return }
            for document in documents {
                guard let member = try? document.data(as: Member.self) else { continue }
                if member.id == memberId {
                    completion(.success(document.documentID))
                }
            }
        }
    }

}

// MARK: - Read
extension FirebaseWorker {

    /// 전체 맴버를 반환합니다.
    func getAllMembers(completion: @escaping (Result<[Member], Error>) -> Void) {
        memberCollectionRef.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            }
            guard let documents = snapshot?.documents else { return }
            let members = documents.compactMap { try? $0.data(as: Member.self) }
            completion(.success(members))
        }
    }

    /// 멤버 문서 id 배열을 반환합니다.
    func getMemberDocumentIdList(completion: @escaping (Result<[String], Error>) -> Void) {
        memberCollectionRef.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            }
            guard let documents = snapshot?.documents else { return }
            let idList = documents.map { $0.documentID }
            completion(.success(idList))
        }
    }

    /// 이미 가입한 유저인지 확인합니다.
    func checkIsRegisteredUser(id: String, completion: @escaping (Bool) -> Void) {
        getMemberDocumentIdList { result in
            switch result {
            case .success(let idList): completion(idList.contains(id))
            case .failure: completion(false)
            }
        }
    }

}
