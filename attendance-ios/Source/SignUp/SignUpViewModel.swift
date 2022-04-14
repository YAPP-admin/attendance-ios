//
//  SignUpViewModel.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/03/08.
//

import RxCocoa
import RxSwift
import UIKit

final class SignUpViewModel: ViewModel {

    struct Input {
        let name = BehaviorSubject<String?>(value: nil)
        let positionType = BehaviorSubject<PositionType?>(value: nil)
        let teamType = BehaviorSubject<TeamType?>(value: nil)
        let teamNumber = BehaviorSubject<Int?>(value: nil)

        let registerInfo = PublishRelay<Void>()
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
    private let firebaseWorker = FirebaseWorker()

    init() {
        setupConfig()
        bindInput()
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

        input.registerInfo
            .subscribe(onNext: { [weak self] _ in
                self?.registerInfo()
            }).disposed(by: disposeBag)
    }

}

extension SignUpViewModel {

    func registerInfo() {
        guard let name = try? input.name.value(),
              let positionType = try? input.positionType.value(),
              let teamType = try? input.teamType.value(),
              let teamNumber = try? input.teamNumber.value() else { return }

        let newUser = FirebaseNewUser(name: name, positionType: positionType, teamType: teamType, teamNumber: teamNumber)

        firebaseWorker.registerInfo(newUser: newUser) { [weak self] result in
            switch result {
            case .success: self?.output.goToHome.accept(())
            case .failure: ()
            }
        }
    }

}
