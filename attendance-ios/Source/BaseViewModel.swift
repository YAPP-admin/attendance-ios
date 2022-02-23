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
        var goToSignUp = PublishRelay<Void>()
        var goToHome = PublishRelay<Void>()
    }

    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()

    init() {
        input.tapLogin
            .subscribe(onNext: { [weak self] _ in
                self?.loginWithKakao()
            })
            .disposed(by: disposeBag)
    }
}

private extension BaseViewModel {

// TODO: - kakao developers에서 yapp 계정에서 애플리케이션 등록 후
// iOS 번들 ID를 attendance-ios로 등록해야 성공함
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
                print("oauthToken: \(oauthToken)")
                self?.output.goToSignUp.accept(())
            }, onError: { error in
                print(error)
                // TODO: - 애플리케이션 등록 후 삭제
                self.output.goToSignUp.accept(())
            })
            .disposed(by: disposeBag)
    }

    func loginWithKakaoAccount() {
        UserApi.shared.rx.loginWithKakaoAccount()
            .subscribe(onNext: { [weak self] oauthToken in
                print("oauthToken: \(oauthToken)")
                self?.output.goToSignUp.accept(())
            }, onError: { error in
                print(error)
                // TODO: - 애플리케이션 등록 후 삭제
                self.output.goToSignUp.accept(())
            })
            .disposed(by: disposeBag)
    }

    func logoutWithKakao() {
        UserApi.shared.rx.logout()
            .subscribe(onCompleted: {
                print("로그아웃 성공")
            }, onError: {error in
                print(error)
            })
            .disposed(by: disposeBag)
    }

}
