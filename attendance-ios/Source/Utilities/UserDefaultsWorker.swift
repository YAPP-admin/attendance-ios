//
//  UserDefaultsWorker.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/04/15.
//

import Foundation

enum UserDefaultsKey: String {
    case kakaoTalkId
    case appleId
}

final class UserDefaultsWorker {

    private let defaults = UserDefaults.standard

    // MARK: - Create, Update
    func set(_ value: Any?, forKey key: UserDefaultsKey) {
        defaults.set(value, forKey: key.rawValue)
    }

    func set(_ value: String, forKey key: UserDefaultsKey) {
        guard value.isEmpty == false else { return }
        defaults.set(value, forKey: key.rawValue)
    }

    // MARK: - Read
    func read(forKey key: UserDefaultsKey) -> Bool {
        defaults.bool(forKey: key.rawValue)
    }

    func read(forKey key: UserDefaultsKey) -> Int {
        defaults.integer(forKey: key.rawValue)
    }

    func read(forKey key: UserDefaultsKey) -> String? {
        defaults.string(forKey: key.rawValue)
    }

    // MARK: - Delete
    func remove(forKey key: UserDefaultsKey) {
        defaults.removeObject(forKey: key.rawValue)
    }

    func clearAll() {
        if let domain = Bundle.main.bundleIdentifier {
            defaults.removePersistentDomain(forName: domain)
        }
    }

}

extension UserDefaultsWorker {

    func hasId() -> Bool {
        (appleId() != nil) || (kakaoTalkId() != nil)
    }

    func appleId() -> String? {
        read(forKey: .appleId)
    }

    func kakaoTalkId() -> String? {
        read(forKey: .kakaoTalkId)
    }

}
