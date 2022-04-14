//
//  BaseViewModel.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/01/31.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKUser
import RxCocoa
import RxKakaoSDKAuth
import RxKakaoSDKUser
import RxSwift

protocol ViewModel {

    associatedtype Input
    associatedtype Output

    var input: Input { get }
    var output: Output { get }
    var disposeBag: DisposeBag { get }

}

final class BaseViewModel: ViewModel {

    struct Input {
        let tapAppleLogin = PublishRelay<Void>()
        let tapKakaoTalkLogin = PublishRelay<Void>()

        let appleId = BehaviorSubject<String>(value: "")
        let kakaoTalkId = BehaviorSubject<String>(value: "")
    }

    struct Output {
        let accessToken = PublishSubject<String>()

        let goToSignUp = PublishRelay<Void>()
        let goToHome = PublishRelay<Void>()
        let goToAdmin = PublishRelay<Void>()
    }

    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()

    private let userDefaultsWorker = UserDefaultsWorker()

    init() {
        checkLoginId()
        logoutWithKakao() // TODO: - 테스트를 위해 추가함, 이후 삭제 필요
        subscribeInput()
    }

    private func subscribeInput() {
        input.tapAppleLogin
            .subscribe(onNext: { [weak self] _ in
                self?.loginWithApple()
            }).disposed(by: disposeBag)

        input.tapKakaoTalkLogin
            .subscribe(onNext: { [weak self] _ in
                self?.loginWithKakao()
            }).disposed(by: disposeBag)

        input.appleId
            .subscribe(onNext: { [weak self] id in
                self?.userDefaultsWorker.set(id, forKey: .appleId)
                self?.output.goToSignUp.accept(())
            }).disposed(by: disposeBag)

        input.kakaoTalkId
            .subscribe(onNext: { [weak self] id in
                self?.userDefaultsWorker.set(id, forKey: .kakaoTalkId)
                self?.output.goToSignUp.accept(())
            }).disposed(by: disposeBag)
    }

}

// MARK: - Login
private extension BaseViewModel {

    func checkLoginId() {
        // TODO: - 파베 문서 있는지 추가 확인
        if userDefaultsWorker.hasLoginId() == true {
            output.goToHome.accept(())
        }
    }

}

// MARK: - Apple Login
extension BaseViewModel {

    func loginWithApple() {

    }

}

// MARK: - Kakao Login
private extension BaseViewModel {

    func loginWithKakao() {
        if UserApi.isKakaoTalkLoginAvailable() {
            loginWithKakaoTalk()
        } else {
            loginWithKakaoAccount()
        }
    }

    func loginWithKakaoTalk() {
        UserApi.shared.rx.loginWithKakaoTalk()
            .subscribe(onNext: { [weak self] oauthToken in
                self?.output.accessToken.onNext(oauthToken.accessToken)
                self?.output.goToSignUp.accept(())
            }, onError: { error in
                print(error)
            }).disposed(by: disposeBag)
    }

    func loginWithKakaoAccount() {
        UserApi.shared.rx.loginWithKakaoAccount()
            .subscribe(onNext: { [weak self] oauthToken in
                self?.output.accessToken.onNext(oauthToken.accessToken)
                self?.output.goToSignUp.accept(())
            }, onError: { error in
                print(error)
            }).disposed(by: disposeBag)
    }

    func logoutWithKakao() {
        UserApi.shared.rx.logout()
            .subscribe(onCompleted: {
                print("로그아웃 성공")
            }, onError: {error in
                print(error)
            }).disposed(by: disposeBag)
    }

}
