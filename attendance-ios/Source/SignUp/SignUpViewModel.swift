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
        let kakaoTalkId = BehaviorSubject<String>(value: "")
        let appleId = BehaviorSubject<String>(value: "")

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
    private let userDefaultsWorker = UserDefaultsWorker()

    init() {
        bindInput()
        setupConfig()
    }

}

// MARK: - Bind
private extension SignUpViewModel {

    func bindInput() {
        input.kakaoTalkId
            .subscribe(onNext: { [weak self] id in
                print("kakaoTalkId: \(id)")
            }).disposed(by: disposeBag)

        input.appleId
            .subscribe(onNext: { [weak self] id in
                print("appleId: \(id)")
            }).disposed(by: disposeBag)

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

    func setLoginId() {
        guard let appleId = try? input.appleId.value(),
              let kakaoTalkId = try? input.kakaoTalkId.value() else { return }

        userDefaultsWorker.set(appleId, forKey: .appleId)
        userDefaultsWorker.set(kakaoTalkId, forKey: .kakaoTalkId)
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

// MARK: - Register
extension SignUpViewModel {

    func registerInfo() {
        guard let appleId = try? input.appleId.value(),
              let kakaoTalkId = try? input.kakaoTalkId.value(),
              let name = try? input.name.value(),
              let positionType = try? input.positionType.value(),
              let teamType = try? input.teamType.value(),
              let teamNumber = try? input.teamNumber.value() else { return }

        let newUser = FirebaseNewUser(name: name, positionType: positionType, teamType: teamType, teamNumber: teamNumber)

        // TODO: - getDocument 함수 만들기
        if kakaoTalkId.isEmpty == false, appleId.isEmpty == false {
//            firebaseWorker.checkIsRegisteredUser(id: kakaoTalkId) { isRegistered in
//                switch result {
//                case .success(let hasDocument):
//                    if hasDocument == false {
//                        // TODO: - appId에 해당하는 문서를 찾아 kakaoTalkId로 변경한다.
//                    }
//                case .failure: ()
//                }
//            }
        }

        if kakaoTalkId.isEmpty == false {
            firebaseWorker.registerInfo(id: kakaoTalkId, newUser: newUser) { [weak self] result in
                switch result {
                case .success: self?.output.goToHome.accept(())
                case .failure: ()
                }
            }
        } else if appleId.isEmpty == false {
            firebaseWorker.registerInfo(id: appleId, newUser: newUser) { [weak self] result in
                switch result {
                case .success: self?.output.goToHome.accept(())
                case .failure: ()
                }
            }
        }
    }

}
