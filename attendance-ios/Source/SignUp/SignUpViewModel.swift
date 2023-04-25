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
        let isGuest = BehaviorSubject<Bool>(value: false)

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
        let goToLoginVC = PublishRelay<Void>()
    }

    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()

    private let configWorker = ConfigWorker.shared
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
        input.name
            .subscribe(onNext: { [weak self] name in
                self?.output.isNameTextFieldValid.onNext(name?.isEmpty == false)
            }).disposed(by: disposeBag)

        input.registerInfo
            .subscribe(onNext: { [weak self] _ in
                self?.registerInfo()
            }).disposed(by: disposeBag)
    }

}

// MARK: - Config
private extension SignUpViewModel {

    func setupConfig() {
        configWorker.decodeYappConfig { [weak self] result in
            switch result {
            case .success(let config):
                self?.output.yappConfig.onNext(config)
                self?.userDefaultsWorker.setGeneration(generation: config.generation)
                self?.userDefaultsWorker.setSessionCount(session: config.sessionCount)
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
              let isGuest = try? input.isGuest.value(),
              let name = try? input.name.value(),
              let positionType = try? input.positionType.value() else { return }

            let newUser = FirebaseNewMember(name: name, positionType: positionType, teamType: TeamType.none, teamNumber: 1)

        if kakaoTalkId.isEmpty == false, let id = Int(kakaoTalkId) {
			userDefaultsWorker.setKakaoTalkId(id: kakaoTalkId)
            registerKakaoUserInfo(id: id, newUser: newUser)
        } else if appleId.isEmpty == false {
			userDefaultsWorker.setAppleId(id: appleId)
            registerWithApple(id: appleId, newUser: newUser)
        } else if isGuest == true {
            let randomId = Int.random(in: 1000000000..<10000000000)
            userDefaultsWorker.setGuestId(id: String(randomId))
            registerGuestUser(id: randomId, newUser: newUser)
        }
    }

    func registerKakaoUserInfo(id: Int, newUser: FirebaseNewMember) {
        firebaseWorker.registerKakaoUserInfo(id: id, newUser: newUser) { [weak self] result in
            switch result {
            case .success: self?.output.goToHome.accept(())
            case .failure: self?.output.goToLoginVC.accept(())
            }
        }
    }

    func registerWithApple(id: String, newUser: FirebaseNewMember) {
        firebaseWorker.registerAppleUserInfo(id: id, newUser: newUser) { [weak self] result in
            switch result {
            case .success: self?.output.goToHome.accept(())
            case .failure: self?.output.goToLoginVC.accept(())
            }
        }
    }

    func registerGuestUser(id: Int, newUser: FirebaseNewMember) {
        firebaseWorker.registerKakaoUserInfo(id: id, newUser: newUser) { [weak self] result in
            switch result {
            case .success: self?.output.goToHome.accept(())
            case .failure: self?.output.goToLoginVC.accept(())
            }
        }
    }

}
