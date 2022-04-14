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

}

struct FirebaseNewUser {
    let name: String
    let positionType: PositionType
    let teamType: TeamType
    let teamNumber: Int
}

extension FirebaseWorker {

    func registerInfo(newUser: FirebaseNewUser, completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("member")

        UserApi.shared.me { [weak self] user, error in
            guard let self = self, let user = user, let userId = user.id else { return }

            docRef.document("\(userId)").setData([
                "id": userId,
                "name": newUser.name,
                "position": newUser.positionType.rawValue,
                "team": ["number": newUser.teamNumber, "type": newUser.teamType.upperCase],
                "attendances": self.makeEmptyAttendances()
            ]) { error in
                guard error == nil else { return }
                completion(.success(()))
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
