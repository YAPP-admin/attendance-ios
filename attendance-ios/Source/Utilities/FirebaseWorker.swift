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
struct FirebaseNewUser {
    let name: String
    let positionType: PositionType
    let teamType: TeamType
    let teamNumber: Int
}

extension FirebaseWorker {

    func registerKakaoUserInfo(id: Int, newUser: FirebaseNewUser, completion: @escaping (Result<Void, Error>) -> Void) {
        memberCollectionRef.document("\(id)").setData([
            "id": id,
            "name": newUser.name,
            "position": newUser.positionType.rawValue,
            "team": ["number": newUser.teamNumber, "type": newUser.teamType.upperCase],
            "attendances": self.makeEmptyAttendances()
        ]) { error in
            guard let error = error else {
                completion(.success(()))
                return
            }
            completion(.failure(error))
        }
    }

    func registerAppleUserInfo(id: String, newUser: FirebaseNewUser, completion: @escaping (Result<Void, Error>) -> Void) {
        memberCollectionRef.document("\(id)").setData([
            "id": Int.random(in: 1000000000..<10000000000),
            "name": newUser.name,
            "position": newUser.positionType.rawValue,
            "team": ["number": newUser.teamNumber, "type": newUser.teamType.upperCase],
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
            let empty: [String: Any] = ["sessionId": id, "type": ["text": "결석", "point": -20]]
            attendances.append(empty)
        }
        return attendances
    }

}

// MARK: - Delete
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

// MARK: - Read
extension FirebaseWorker {

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

    /// 문서 이름을 애플 아이디에서 카카오톡 아이디로 변경합니다.
    func changeDocumentName(_ appleId: String, to kakaoId: String, completion: @escaping (Result<Attendance, Error>) -> Void) {
        let docRef = memberCollectionRef.document(appleId)
        docRef.getDocument { [weak self] snapshot, error in
            if let error = error {
                completion(.failure(error))
            }
            guard let self = self, let data = snapshot?.data(), let newId = Int(kakaoId) else { return }
            print("📌data: \(data)")
            print("📌newId: \(newId)")

            // TODO: - 임의의 FirebaseNewUser 정보로 변경 필요
            let newUser = FirebaseNewUser(name: "기존 애플 유저 파일 이동 테스트", positionType: .ios, teamType: .ios, teamNumber: 1)
            self.registerKakaoUserInfo(id: newId, newUser: newUser) { result in
                switch result {
                case .success: self.deleteDocument(id: appleId)
                case .failure: ()
                }
            }

        }
    }

    func changeDocumentName(id: String) {

    }

}
