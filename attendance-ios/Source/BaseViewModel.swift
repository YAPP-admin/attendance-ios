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

protocol ViewModel {

    associatedtype Input
    associatedtype Output

    var input: Input { get }
    var output: Output { get }
    var disposeBag: DisposeBag { get }

}

final class BaseViewModel: ViewModel {

    struct Input {
//        let tapAppleLogin = PublishRelay<Void>()
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
        logoutWithKakao() // TODO: - 테스트 위해 추가
        checkLoginId()

        subscribeInput()
    }

    private func subscribeInput() {
        input.tapKakaoTalkLogin
            .subscribe(onNext: { [weak self] _ in
                self?.loginWithKakao()
            }).disposed(by: disposeBag)

//        input.tapAppleLogin
//            .subscribe(onNext: { [weak self] _ in
//                self?.loginWithApple()
//            }).disposed(by: disposeBag)
    }

}

// MARK: - Check
private extension BaseViewModel {

    func checkLoginId() {
        if let kakaoTalkId = userDefaultsWorker.kakaoTalkId(), kakaoTalkId.isEmpty == false {
            print("📌kakaoTalkId: \(kakaoTalkId)")
            output.kakaoTalkId.onNext(kakaoTalkId)
            output.goToHome.accept(())
        } else if let appleId = userDefaultsWorker.appleId(), appleId.isEmpty == false {
            print("📌appleId: \(appleId)")
            output.appleId.onNext(appleId)
            output.goToHome.accept(())
        } else {
            print("📌no id")
            output.goToSignUp.accept(())
        }
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
                    print("📌id: \(id)")
                    self.output.accessToken.onNext(accessToken)
                    self.userDefaultsWorker.setKakaoTalkId(id: String(id))
                }
            case .failure: ()
            }
        }
    }

    func logoutWithKakao() {
        kakaoLoginWorker.logoutWithKakao()
    }

}

// MARK: - Apple Login
extension BaseViewModel {

    func authorizationController(authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            print("📌id : \(userIdentifier)")
            print("📌familyName : \(fullName?.familyName ?? "")")
            print("📌givenName : \(fullName?.givenName ?? "")")
            print("📌email : \(email ?? "")")
            output.appleId.onNext(userIdentifier)
        default: break
        }
    }

}
