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
        let tapLogin = PublishRelay<Void>()
    }

    struct Output {
        let accessToken = PublishSubject<String>()

        let goToSignUp = PublishRelay<Void>()
        let goToHome = PublishRelay<Void>()
    }

    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()

    init() {
        //TODO: - 테스트 후 삭제
        logoutWithKakao()

        input.tapLogin
            .subscribe(onNext: { [weak self] _ in
                self?.loginWithKakao()
            }).disposed(by: disposeBag)
    }

}

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
