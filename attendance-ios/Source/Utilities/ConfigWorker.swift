//
//  ConfigWorker.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/04/07.
//

import FirebaseFirestore
import FirebaseRemoteConfig

/// Firebase의 Config를 관리하는 클래스입니다.
final class ConfigWorker {

    private let remoteConfig: RemoteConfig = {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        return remoteConfig
    }()

    /// attendance_session_list
    func decodeSessionList(completion: @escaping (Result<[Session], Error>) -> Void) {
        remoteConfig.fetch { [weak self] status, _ in
            guard let self = self, status == .success else { return }
            self.remoteConfig.activate { _, _ in
                guard let configString = self.remoteConfig[Config.sessionList.rawValue].stringValue,
                      let configData = configString.data(using: .utf8),
                      let sessions = try? JSONDecoder().decode([Session].self, from: configData) else { return }
                completion(.success(sessions))
            }
        }
    }

    /// config
    func decodeYappConfig(completion: @escaping (Result<YappConfig, Error>) -> Void) {
        remoteConfig.fetch { [weak self] status, _ in
            guard let self = self, status == .success else { return }
            self.remoteConfig.activate { _, _ in
                guard let configString = self.remoteConfig[Config.yappConfig.rawValue].stringValue,
                      let configData = configString.data(using: .utf8),
                      let config = try? JSONDecoder().decode(YappConfig.self, from: configData) else { return }
                completion(.success(config))
            }
        }
    }

    /// attendance_select_teams
    func decodeSelectTeams(completion: @escaping (Result<[Team], Error>) -> Void) {
        remoteConfig.fetch { [weak self] status, _ in
            guard let self = self, status == .success else { return }
            self.remoteConfig.activate { _, _ in
                guard let configString = self.remoteConfig[Config.selectTeams.rawValue].stringValue,
                      let configData = configString.data(using: .utf8),
                      let teams = try? JSONDecoder().decode([Team].self, from: configData) else { return }
                completion(.success(teams))
            }
        }
    }

    /// attendance_maginotline_time
    func decodeMaginotlineTime(completion: @escaping (Result<String, Error>) -> Void) {
        remoteConfig.fetch { [weak self] status, _ in
            guard let self = self, status == .success else { return }
            self.remoteConfig.activate { _, _ in
                guard let maginotlineTime = self.remoteConfig[Config.maginotlineTime.rawValue].stringValue else { return }
                completion(.success(maginotlineTime))
            }
        }
    }

    /// attendance_qr_password
	func decodeQrPassword(completion: @escaping (Result<String, Error>) -> Void) {
		remoteConfig.fetch { [weak self] status, _ in
			guard let self = self, status == .success else { return }
			self.remoteConfig.activate { _, _ in
				guard let qrPassword = self.remoteConfig[Config.qrPassword.rawValue].stringValue else { return }
				completion(.success(qrPassword))
			}
		}
	}

    /// should_show_guest_button
    func decodeShouldShowGuestButton(completion: @escaping (Result<Bool, Error>) -> Void) {
        remoteConfig.fetch { [weak self] status, _ in
            guard let self = self, status == .success else { return }
            self.remoteConfig.activate { _, _ in
                let showGuestButton = self.remoteConfig[Config.showGuestButton.rawValue].boolValue
                completion(.success(showGuestButton))
            }
        }
    }

}
