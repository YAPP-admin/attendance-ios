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
        let teamIndex = BehaviorSubject<Int>(value: 0)
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

        input.teamIndex
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

        remoteConfig.fetch { status, _ in
            guard status == .success else { return }
            remoteConfig.activate { _, _ in
                let decoder = JSONDecoder()

                guard let configString = remoteConfig[ConfigKeys.config.rawValue].stringValue,
                      let configData = configString.data(using: .utf8),
                      let config = try? decoder.decode(Config.self, from: configData) else { return }
                print("config: \(config)")

                guard let selectTeamsString = remoteConfig[ConfigKeys.selectTeams.rawValue].stringValue,
                      let selectTeamsData = selectTeamsString.data(using: .utf8),
                      let selectTeams = try? decoder.decode([ConfigSelectTeams].self, from: selectTeamsData) else { return }
                print("selectTeams: \(selectTeams)")

            }
        }
    }

}
