//
//  BaseViewModel.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/01/31.
//

import Foundation
import RxCocoa
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
    }

    struct Output {
        let kakaoTalkId = BehaviorSubject<String>(value: "")
        let appleId = BehaviorSubject<String>(value: "")
        let accessToken = PublishSubject<String>()

        let goToSignUp = PublishRelay<Void>()
        let goToHome = PublishRelay<Void>()
        let goToAdmin = PublishRelay<Void>()
    }

    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()

    private let kakaoLoginWorker = KakaoLoginWorker()
    private let firebaseWorker = FirebaseWorker()
    private let userDefaultsWorker = UserDefaultsWorker()

    init() {
        checkUserDefaults()

        logoutWithKakao() // TODO: - 테스트를 위해 추가함, 이후 삭제 필요

        subscribeInput()
    }

    private func subscribeInput() {
        input.tapKakaoTalkLogin
            .subscribe(onNext: { [weak self] _ in
                self?.loginWithKakao()
            }).disposed(by: disposeBag)

        input.tapAppleLogin
            .subscribe(onNext: { [weak self] _ in
                self?.loginWithApple()
            }).disposed(by: disposeBag)
    }

}

// MARK: - Check
private extension BaseViewModel {

    func checkUserDefaults() {
        checkKakaoId()
        checkAppleId()
        output.goToSignUp.accept(())
    }

    func checkKakaoId() {
        guard let kakaoTalkId = userDefaultsWorker.kakaoTalkId() else { return }
        output.kakaoTalkId.onNext(kakaoTalkId)
        output.goToHome.accept(())
    }

    func checkAppleId() {
        guard let appleId = userDefaultsWorker.appleId() else { return }
        output.appleId.onNext(appleId)
        output.goToHome.accept(())
    }

}

// MARK: - Kakao Login
private extension BaseViewModel {

    func loginWithKakao() {
        kakaoLoginWorker.loginWithKakao { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let accessToken):
                self.output.accessToken.onNext(accessToken)
                self.checkUserDefaults()
            case .failure: ()
            }
        }
    }

    func logoutWithKakao() {
        kakaoLoginWorker.logoutWithKakao()
    }

}

// MARK: - Apple Login
// LoginViewController에 있음, 뷰모델로 이동 필요
private extension BaseViewModel {

    func loginWithApple() {

    }

}
