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
        let configTeams = BehaviorSubject<[Team]>(value: [])

        let generation = BehaviorSubject<Int>(value: 0)

        let isNameTextFieldValid = BehaviorSubject(value: false)
        let showTeamNumber = PublishRelay<Void>()

        let complete = PublishRelay<Void>()
        let goToHome = PublishRelay<Void>()
    }

    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()

    private let configWorker = ConfigWorker()

    init() {
        setupConfig()
        bindInput()
        bindOutput()
    }

}

// MARK: - Bind
private extension SignUpViewModel {

    private func subscribeInputs() {
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

// MARK: - Config
private extension SignUpViewModel {

    func setupConfig() {
        configWorker.decodeYappConfig { [weak self] result in
            switch result {
            case .success(let config): self?.output.yappConfig.onNext(config)
            case .failure: ()
            }
        }

        configWorker.decodeSelectTeams { [weak self] result in
            switch result {
            case .success(let teams): self?.output.configTeams.onNext(teams)
            case .failure: ()
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
                "team": ["number": teamNumber, "type": teamType.upperCase],
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
            let empty: [String: Any] = ["sessionId": id, "attendanceType": ["text": "결석", "point": -20]]
            attendances.append(empty)
        }
        return attendances
    }

}
