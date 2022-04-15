//
//  FirebaseWorker.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/04/14.
//

import FirebaseFirestore
import FirebaseRemoteConfig
import KakaoSDKUser
import UIKit

final class FirebaseWorker {

    private let memberDocRef = Firestore.firestore().collection("member")

}

// MARK: - Register
struct FirebaseNewUser {
    let name: String
    let positionType: PositionType
    let teamType: TeamType
    let teamNumber: Int
}

extension FirebaseWorker {

    func registerInfo(id: Int, newUser: FirebaseNewUser, completion: @escaping (Result<Void, Error>) -> Void) {
        memberDocRef.document("\(id)").setData([
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
        memberDocRef.document(id).delete()
    }

}

// MARK: - Read
extension FirebaseWorker {

    /// 맴버 문서 id 배열을 반환합니다.
    func getMemberDocumentIdList(completion: @escaping (Result<[String], Error>) -> Void) {
        memberDocRef.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            }
            guard let documents = snapshot?.documents else { return }
            let idList = documents.map { $0.data() }.compactMap { $0["id"] as? String }
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

    /// 문서를 반환합니다.
    func getDocument() {

    }

}
