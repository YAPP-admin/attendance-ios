//
//  SignUpViewModel.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/03/08.
//

import FirebaseRemoteConfig
import RxCocoa
import RxSwift
import UIKit

final class SignUpViewModel: ViewModel {

    struct Input {
        let name = BehaviorSubject<String>(value: "")
        let positionIndex = BehaviorSubject<Int>(value: 0)
        let teamNumber = BehaviorSubject<Int>(value: 0)

        let config = BehaviorSubject<Config?>(value: nil)
        let configTeams = BehaviorSubject<[ConfigTeam]>(value: [])
    }

    struct Output {
        let isNameTextFieldValid = BehaviorSubject(value: false)
        let showTeamList = PublishRelay<Void>()
        let complete = PublishRelay<Void>()
    }

    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()

    let positions: [String] = ["All-Rounder", "Android", "iOS", "Web"]
    let teamCount: Int = 2

    init() {
        setupConfig()

        input.name
            .subscribe(onNext: { [weak self] name in
                self?.output.isNameTextFieldValid.onNext(!name.isEmpty)
            }).disposed(by: disposeBag)

        input.positionIndex
            .subscribe(onNext: { [weak self] _ in
                self?.output.showTeamList.accept(())
            }).disposed(by: disposeBag)

        input.teamNumber
            .subscribe(onNext: { [weak self] _ in
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
                print("config: \(config)")
                self.input.config.onNext(config)

                guard let configTeamString = remoteConfig[ConfigKeys.selectTeams.rawValue].stringValue,
                      let configTeamData = configTeamString.data(using: .utf8),
                      let configTeams = try? decoder.decode([ConfigTeam].self, from: configTeamData) else { return }
                print("configTeams: \(configTeams)")
                self.input.configTeams.onNext(configTeams)
            }
        }
    }

}
