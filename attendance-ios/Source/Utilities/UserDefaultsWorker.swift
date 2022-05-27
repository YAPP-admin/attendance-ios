//
//  UserDefaultsWorker.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/04/15.
//

import Foundation

final class UserDefaultsWorker {

    enum UserDefaultsKey: String {
        case kakaoTalkId, appleId
        case generation, session
        case memberId, name
        case isFirstSplash
    }

    private let defaults = UserDefaults.standard

    // MARK: - Set
    func set(_ value: Any?, forKey key: UserDefaultsKey) {
        defaults.set(value, forKey: key.rawValue)
    }

    func set(_ value: String, forKey key: UserDefaultsKey) {
        guard value.isEmpty == false else { return }
        defaults.set(value, forKey: key.rawValue)
    }

    func set(_ value: Bool, forKey key: UserDefaultsKey) {
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

    func hasLoginId() -> Bool {
        lazy var kakaoTalkId = getKakaoTalkId()
        lazy var appId = getAppleId()

        guard kakaoTalkId?.isEmpty == true, appId?.isEmpty == true else { return true }
        return false
    }

    func setKakaoTalkId(id: String) {
        set(id, forKey: .kakaoTalkId)
    }

    func setAppleId(id: String) {
        set(id, forKey: .appleId)
    }

    func getKakaoTalkId() -> String? {
        get(forKey: .kakaoTalkId)
    }

    func getAppleId() -> String? {
        get(forKey: .appleId)
    }

    func removeKakaoTalkId() {
        remove(forKey: .kakaoTalkId)
    }

    func removeAppleId() {
        remove(forKey: .appleId)
    }

    func removeAllLoginId() {
        removeKakaoTalkId()
        removeAppleId()
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

// MARK: - Member
extension UserDefaultsWorker {
    func setMemberId(memberId: Int) {
        set(memberId, forKey: .memberId)
    }

    func getMemberId() -> Int? {
        get(forKey: .memberId)
    }

    func setName(name: String) {
        set(name, forKey: .name)
    }

    func getName() -> String? {
        get(forKey: .name)
    }
}

// MARK: - Splash
extension UserDefaultsWorker {
    func setIsFirstSplash(isFirst: Bool) {
        set(isFirst, forKey: .isFirstSplash)
    }

    func getIsFirstSplash() -> Bool? {
        get(forKey: .isFirstSplash)
    }
}
