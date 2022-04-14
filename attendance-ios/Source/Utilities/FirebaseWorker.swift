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

    private let docRef = Firestore.firestore().collection("member")

}

// MARK: - Register
struct FirebaseNewUser {
    let name: String
    let positionType: PositionType
    let teamType: TeamType
    let teamNumber: Int
}

extension FirebaseWorker {

    func registerInfo(newUser: FirebaseNewUser, completion: @escaping (Result<Void, Error>) -> Void) {
        UserApi.shared.me { [weak self] user, error in
            guard let self = self, let user = user, let userId = user.id else { return }

            self.docRef.document("\(userId)").setData([
                "id": userId,
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
    }

    private func makeEmptyAttendances() -> [[String: Any]] {
        var attendances: [[String: Any]] = []
        let sessionCount = 20
        for id in 0..<sessionCount {
            let empty: [String: Any] = ["sessionId": id, "attendanceType": ["text": "결석", "point": -20]]
            attendances.append(empty)
        }
        return attendances
    }

}

// MARK: - Delete
extension FirebaseWorker {

    func deleteUserInfo() {
        UserApi.shared.me { [weak self] user, _ in
            guard let self = self, let userId = user?.id else { return }
            self.docRef.document("\(userId)").delete()
        }
    }

}

// MARK: - Read
extension FirebaseWorker {

    func getDocumentIdList(completion: @escaping (Result<[String], Error>) -> Void) {
        docRef.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            }
            guard let documents = snapshot?.documents else { return }
            let idList = documents.map { $0.data() }.compactMap { $0["id"] as? String }
            completion(.success(idList))
        }
    }

    func checkIsExistingUser(id: String, completion: @escaping (Bool) -> Void) {
        getDocumentIdList { result in
            switch result {
            case .success(let idList): completion(idList.contains(id))
            case .failure: completion(false)
            }
        }
    }

    func getDocument() {

    }

}
