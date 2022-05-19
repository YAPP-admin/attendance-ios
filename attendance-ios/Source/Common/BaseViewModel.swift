//
//  BaseViewModel.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/01/31.
//

import AuthenticationServices
import Foundation
import RxCocoa
import RxSwift

import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseRemoteConfig
import KakaoSDKUser
import UIKit

protocol ViewModel {

    associatedtype Input
    associatedtype Output

    var input: Input { get }
    var output: Output { get }
    var disposeBag: DisposeBag { get }

}

final class BaseViewModel: ViewModel {

    struct Input {
        let tapKakaoTalkLogin = PublishRelay<Void>()
        let tapEasterEgg = PublishRelay<Void>()
        let easterEggKey = BehaviorSubject<String>(value: "")
        let tapEasterEggOkButton = PublishRelay<Void>()
    }

    struct Output {
        let kakaoAccessToken = PublishSubject<String>()
        let kakaoTalkId = BehaviorSubject<String>(value: "")
        let appleId = BehaviorSubject<String>(value: "")

        let yappConfig = BehaviorSubject<YappConfig?>(value: nil)
        let easterEggCount = BehaviorSubject<Int>(value: 0)
        let isEasterEggKeyValid = BehaviorSubject<Bool?>(value: nil)
        let isFirstSplash = BehaviorSubject<Bool>(value: true)

        let failedToLogin = PublishRelay<Void>()
        let goToSignUp = PublishRelay<Void>()
        let goToHome = PublishRelay<Void>()
        let goToAdmin = PublishRelay<Void>()
        let showEasterEgg = PublishRelay<Void>()
    }

    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()

    private let kakaoLoginWorker = KakaoLoginWorker()
    private let firebaseWorker = FirebaseWorker()
    private let userDefaultsWorker = UserDefaultsWorker()
    private let configWorker = ConfigWorker()

    init() {
        setupConfig()
        setIsFirstSplash()
        subscribeInput()
    }

    private func subscribeInput() {
        input.tapKakaoTalkLogin
            .subscribe(onNext: { [weak self] _ in
                self?.loginWithKakao()
            }).disposed(by: disposeBag)

        input.tapEasterEgg
            .subscribe(onNext: { [weak self] _ in
                self?.tapEasterEgg()
            }).disposed(by: disposeBag)

        input.tapEasterEggOkButton
            .subscribe(onNext: { [weak self] _ in
                self?.checkEasterEggKey()
            }).disposed(by: disposeBag)
    }

}

// MARK: - Check
extension BaseViewModel {

    @discardableResult
    private func checkLoginId() -> Bool {
        guard checkKakaoId() == false, checkAppleId() == false else { return true }
        return false
    }

    @discardableResult
    func checkKakaoId() -> Bool {
        guard let kakaoTalkId = userDefaultsWorker.getKakaoTalkId(), kakaoTalkId.isEmpty == false else { return false }
        output.kakaoTalkId.onNext(kakaoTalkId)
        output.goToHome.accept(())
        return true
    }

    @discardableResult
    private func checkAppleId() -> Bool {
        guard let appleId = userDefaultsWorker.getAppleId(), appleId.isEmpty == false else { return false }
        output.appleId.onNext(appleId)
        return true
    }

}

// MARK: - Kakao Login
private extension BaseViewModel {

    func loginWithKakao() {
        kakaoLoginWorker.loginWithKakao { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let accessToken):
                self.kakaoLoginWorker.userId { [weak self] id in
                    guard let self = self else { return }
                    let kakaoId = String(id)
                    self.output.kakaoAccessToken.onNext(accessToken)
                    self.output.kakaoTalkId.onNext(kakaoId)

                    // MARK: - 애플 로그인을 통해 이미 가입한 유저라면 기존 문서 이름 변경
                    if let appleId = try? self.output.appleId.value() {
                        self.firebaseWorker.changeMemberDocumentName(appleId, to: kakaoId) { result in
                            switch result {
                            case .success:
                                self.userDefaultsWorker.removeAppleId()
                                self.output.goToHome.accept(())
                            case .failure: self.output.goToSignUp.accept(())
                            }
                        }
                    }

                    // MARK: - 이미 가입한 카카오톡 유저인지 확인
                    self.firebaseWorker.checkIsRegisteredUser(id: kakaoId) { isRegistered in
                        // MARK: - 가입하지 않은 카카오톡 유저
                        guard isRegistered == true else {
                            self.output.goToSignUp.accept(())
                            return
                        }
                        // MARK: - 이미 가입한 카카오톡 유저
                        self.userDefaultsWorker.setKakaoTalkId(id: kakaoId)
                        self.output.goToHome.accept(())
                    }
                }
            case .failure: self.output.failedToLogin.accept(())
            }
        }
    }

    func logoutWithKakao() {
        kakaoLoginWorker.logoutWithKakao()
        userDefaultsWorker.removeKakaoTalkId()
    }

}

// MARK: - Apple Login
extension BaseViewModel {

    func authorizationController(authorization: ASAuthorization) {
        switch authorization.credential {
        case _ as ASAuthorizationAppleIDCredential:
            guard checkLoginId() == false else { return }
            signUpWithApple()
        default: self.output.failedToLogin.accept(())
        }
    }

    private func signUpWithApple() {
        let randomId = Int.random(in: 1000000000..<10000000000)
        let stringId = String(randomId)
        output.appleId.onNext(stringId)
        output.goToSignUp.accept(())
    }

}

// MARK: - Easter Egg
private extension BaseViewModel {

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
    }

    func tapEasterEgg() {
        guard var count = try? output.easterEggCount.value() else { return }
        count += 1
        print(count)
        if count < 15 {
            output.easterEggCount.onNext(count)
            return
        }
        showEasterEgg()
    }

    func showEasterEgg() {
        output.easterEggCount.onNext(0)
        output.showEasterEgg.accept(())
    }

    func checkEasterEggKey() {
        guard let key = try? input.easterEggKey.value(),
              let adminPassword = try? output.yappConfig.value()?.adminPassword else { return }
        let isValid = (key == adminPassword)
        output.isEasterEggKeyValid.onNext(isValid)
        if isValid == true {
            output.goToAdmin.accept(())
        }
    }

}

// MARK: - Splash
extension BaseViewModel {

    func setupAfterSplashShowed() {
        userDefaultsWorker.setIsFirstSplash(isFirst: false)
        output.isFirstSplash.onNext(false)
    }

    func setIsFirstSplash() {
        let isFirst = userDefaultsWorker.getIsFirstSplash()
        output.isFirstSplash.onNext(isFirst ?? true)
    }

}
