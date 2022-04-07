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
        let positionType = BehaviorSubject<PositionType?>(value: nil)
        let teamType = BehaviorSubject<TeamType?>(value: nil)
        let teamNumber = BehaviorSubject<Int?>(value: nil)
    }

    struct Output {
        let yappConfig = BehaviorSubject<YappConfig?>(value: nil)
        let configTeams = BehaviorSubject<[ConfigTeam]>(value: [])

        let generation = BehaviorSubject<Int>(value: 0)

        let isNameTextFieldValid = BehaviorSubject(value: false)
        let showTeamNumber = PublishRelay<Void>()

        let complete = PublishRelay<Void>()
        let goToHome = PublishRelay<Void>()
    }

    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()

    init() {
        setupConfig()
        bindInput()
        bindOutput()
    }

}

// MARK: - Bind
private extension SignUpViewModel {

    func bindInput() {
        input.name
            .subscribe(onNext: { [weak self] name in
                self?.output.isNameTextFieldValid.onNext(name?.isEmpty == false)
            }).disposed(by: disposeBag)

        input.teamType
            .subscribe(onNext: { [weak self] _ in
                self?.output.showTeamNumber.accept(())
            }).disposed(by: disposeBag)

        input.teamNumber
            .subscribe(onNext: { [weak self] _ in
                self?.output.complete.accept(())
            }).disposed(by: disposeBag)
    }

    // MARK: - 테스트를 위해 출력, 이후 삭제
    func bindOutput() {
        output.yappConfig
            .subscribe(onNext: { [weak self] yappConfig in
                print("yappConfig: \(yappConfig)")
            }).disposed(by: disposeBag)

        output.configTeams
            .subscribe(onNext: { [weak self] configTeams in
                print("configTeams: \(configTeams)")
            }).disposed(by: disposeBag)
    }

}

private extension SignUpViewModel {

    func setupConfig() {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings

        remoteConfig.fetch { [weak self] status, _ in
            guard let self = self, status == .success else { return }
            remoteConfig.activate { _, _ in
                let decoder = JSONDecoder()

                guard let configString = remoteConfig[Config.config.rawValue].stringValue,
                      let configData = configString.data(using: .utf8),
                      let config = try? decoder.decode(YappConfig.self, from: configData) else { return }
                self.output.yappConfig.onNext(config)

                guard let configTeamString = remoteConfig[Config.selectTeams.rawValue].stringValue,
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
              let positionType = try? input.positionType.value(),
              let teamType = try? input.teamType.value(),
              let teamNumber = try? input.teamNumber.value() else { return }

        let db = Firestore.firestore()
        let docRef = db.collection("member")

        UserApi.shared.me { [weak self] user, error in
            guard let self = self, let user = user, let userId = user.id else { return }

            docRef.document("\(userId)").setData([
                "id": userId,
                "name": name,
                "position": positionType.rawValue,
                "team": ["number": teamNumber, "type": teamType.rawValue],
                "attendances": self.makeEmptyAttendances()
            ]) { [weak self] error in
                guard error == nil else { return }
                self?.output.goToHome.accept(())
            }
        }
    }

    private func makeEmptyAttendances() -> [[String: Any]] {
        var attendances: [[String: Any]] = []
        let sessionCount = 20
        for id in 0..<sessionCount {
            let empty: [String: Any] = ["sessionId": id, "attendanceType": ["text": "미통보 결석", "point": -20]]
            attendances.append(empty)
        }
        return attendances
    }

}
