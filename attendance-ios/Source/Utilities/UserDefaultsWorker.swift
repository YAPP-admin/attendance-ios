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
    case generation
    case session
}

final class UserDefaultsWorker {

    private let defaults = UserDefaults.standard

    // MARK: - Set
    func set(_ value: Any?, forKey key: UserDefaultsKey) {
        defaults.set(value, forKey: key.rawValue)
    }

    func set(_ value: String, forKey key: UserDefaultsKey) {
        guard value.isEmpty == false else { return }
        defaults.set(value, forKey: key.rawValue)
    }

    // MARK: - Get
    func get(forKey key: UserDefaultsKey) -> Bool {
        defaults.bool(forKey: key.rawValue)
    }

    func get(forKey key: UserDefaultsKey) -> Int {
        defaults.integer(forKey: key.rawValue)
    }

    func get(forKey key: UserDefaultsKey) -> String? {
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

// MARK: - LoginId
extension UserDefaultsWorker {

    func hasId() -> Bool {
        if let kakaoTalkId = kakaoTalkId(), kakaoTalkId.isEmpty == false {
            return true
        }
        if let appId = appleId(), appId.isEmpty == false {
            return true
        }
        return false
    }

    func setKakaoTalkId(id: String) {
        set(id, forKey: .kakaoTalkId)
    }

    func setAppleId(id: String) {
        set(id, forKey: .appleId)
    }

    func kakaoTalkId() -> String? {
        get(forKey: .kakaoTalkId)
    }

    func appleId() -> String? {
        get(forKey: .appleId)
    }

    func removeKakaoTalkId() {
        remove(forKey: .kakaoTalkId)
    }

    func removeAppleId() {
        remove(forKey: .appleId)
    }
}

// MARK: - YappConfig
extension UserDefaultsWorker {
    func setGeneration(generation: Int) {
        set(generation, forKey: .generation)
    }

    func getGeneration() -> String? {
        get(forKey: .generation)
    }

    func setSessionCount(session: Int) {
        set(session, forKey: .session)
    }

    func getSessionCount() -> String? {
        get(forKey: .session)
    }
}
