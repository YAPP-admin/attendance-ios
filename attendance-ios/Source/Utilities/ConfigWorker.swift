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

    /// YAPP 세션 리스트를 반환합니다.
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

    /// 전반적인 앱 설정값을 반환합니다.
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

    /// 선택할 팀 배열을 반환합니다.
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

    /// 출석 체크 시간 값을 반환합니다.
    func decodeMaginotlineTime(completion: @escaping (Result<String, Error>) -> Void) {
        remoteConfig.fetch { [weak self] status, _ in
            guard let self = self, status == .success else { return }
            self.remoteConfig.activate { _, _ in
                guard let maginotlineTime = self.remoteConfig[Config.maginotlineTime.rawValue].stringValue else { return }
                completion(.success(maginotlineTime))
            }
        }
    }

	/// 출석 QR에 포함된 비밀번호(임의로 QR을 생성하여 출석을 진행하지 않도록 하기 위함) 값을 반환합니다.
	func decodeQrPassword(completion: @escaping (Result<String, Error>) -> Void) {
		remoteConfig.fetch { [weak self] status, _ in
			guard let self = self, status == .success else { return }
			self.remoteConfig.activate { _, _ in
				guard let qrPassword = self.remoteConfig[Config.qrPassword.rawValue].stringValue else { return }
				completion(.success(qrPassword))
			}
		}
	}

}
