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
        let goToAdmin = PublishRelay<Void>()
    }

    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()

    private let kakaoLoginWorker = KakaoLoginWorker()

    init() {
        logoutWithKakao()
        subscribeInputs()
    }

    private func subscribeInputs() {
        input.tapLogin
            .subscribe(onNext: { [weak self] _ in
                self?.loginWithKakao()
            }).disposed(by: disposeBag)
    }

}

// MARK: - Login
private extension BaseViewModel {

    func loginWithKakao() {
        kakaoLoginWorker.loginWithKakao { [weak self] result in
            switch result {
            case .success(let accessToken):
                self?.output.accessToken.onNext(accessToken)
                self?.output.goToSignUp.accept(())
            case .failure: ()
            }
        }
    }

    func logoutWithKakao() {
        kakaoLoginWorker.logoutWithKakao()
    }

}
