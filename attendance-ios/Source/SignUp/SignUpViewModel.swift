//
//  SignUpViewModel.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/03/08.
//

import FirebaseFirestore
import FirebaseRemoteConfig
import KakaoSDKUser
import RxCocoa
import RxSwift
import UIKit

final class SignUpViewModel: ViewModel {

    struct Input {
        let name = BehaviorSubject<String?>(value: nil)
        let position = BehaviorSubject<PositionType?>(value: nil)
        let platform = BehaviorSubject<PlatformType?>(value: nil)
        let teamNumber = BehaviorSubject<Int?>(value: nil)
    }

    struct Output {
        let config = BehaviorSubject<Config?>(value: nil)
        let configTeams = BehaviorSubject<[ConfigTeam]>(value: [])

        let generation = BehaviorSubject<Int>(value: 0)

        let isNameTextFieldValid = BehaviorSubject(value: false)
        let showTeamCount = PublishRelay<Void>()

        let complete = PublishRelay<Void>()
        let goToHome = PublishRelay<Void>()
    }

    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()

    init() {
        setupConfig()

        // TODO: - 테스트용 print문 회원가입 구현 후 제거
        input.name
            .subscribe(onNext: { [weak self] name in
                print("name: \(name)")
                self?.output.isNameTextFieldValid.onNext(name?.isEmpty == false)
            }).disposed(by: disposeBag)

        input.position
            .subscribe(onNext: { [weak self] position in
                print("position: \(position)")
            }).disposed(by: disposeBag)

        input.platform
            .subscribe(onNext: { [weak self] platform in
                print("platform: \(platform)")
                self?.output.showTeamCount.accept(())
            }).disposed(by: disposeBag)

        input.teamNumber
            .subscribe(onNext: { [weak self] teamNumber in
                print("teamNumber: \(teamNumber)")
                self?.output.complete.accept(())
            }).disposed(by: disposeBag)
    }

}

private extension SignUpViewModel {

    enum ConfigKeys: String {
        case sessionList = "attendance_session_list"
        case config = "config"
        case selectTeams = "attendance_select_teams"
        case maginotlineTime = "attendance_maginotline_time"
    }

    func setupConfig() {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings

        remoteConfig.fetch { [weak self] status, _ in
            guard let self = self, status == .success else { return }
            remoteConfig.activate { _, _ in
                let decoder = JSONDecoder()

                guard let configString = remoteConfig[ConfigKeys.config.rawValue].stringValue,
                      let configData = configString.data(using: .utf8),
                      let config = try? decoder.decode(Config.self, from: configData) else { return }
                self.output.config.onNext(config)

                guard let configTeamString = remoteConfig[ConfigKeys.selectTeams.rawValue].stringValue,
                      let configTeamData = configTeamString.data(using: .utf8),
                      let configTeams = try? decoder.decode([ConfigTeam].self, from: configTeamData) else { return }
                self.output.configTeams.onNext(configTeams)
            }
        }
    }

}

extension SignUpViewModel {

    func registerInfo() {
        guard let name = try? input.name.value(),
              let position = try? input.position.value(),
              let platform = try? input.platform.value(),
              let teamNumber = try? input.teamNumber.value() else { return }

        let db = Firestore.firestore()
        let docRef = db.collection("member")

        UserApi.shared.me { [weak self] user, error in
            guard let self = self, let user = user, let userId = user.id else { return }
            let member = Member(id: Int(userId), name: name, position: position, team: Team(platform: platform, teamNumber: teamNumber), attendances: Attendance.defaults)

            guard let data = try? JSONEncoder().encode(member), let json = String(data: data, encoding: .utf8) else { return }
            print("json: \(json)")

            docRef.document("\(userId)").setData([
                "id": userId,
                "name": name,
                "position": "position",
                "team": "team",
                "attendances": "[]"
            ]) { [weak self] error in
                guard error == nil else { return }
                self?.output.goToHome.accept(())
            }
        }
    }

}

fileprivate extension Attendance {

    static var defaults: [Attendance] {
        let sessionCount = 20
        var attendances: [Attendance] = []
        for id in 0..<sessionCount {
            attendances.append(Attendance(sesstionId: id, attendanceType: .notMentionedAbsence))
        }
        return attendances
    }

}
