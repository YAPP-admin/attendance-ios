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
        let tapKakaoTalkLogin = PublishRelay<Void>()
    }

    struct Output {
        let kakaoAccessToken = PublishSubject<String>()
        let kakaoTalkId = BehaviorSubject<String>(value: "")
        let appleId = BehaviorSubject<String>(value: "")

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
        // TODO: - 테스트를 위해 추가
        logoutWithKakao()
        //

        checkLoginId()

        subscribeInput()
    }

    private func subscribeInput() {
        input.tapKakaoTalkLogin
            .subscribe(onNext: { [weak self] _ in
                self?.loginWithKakao()
            }).disposed(by: disposeBag)
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
                    let stringId = String(id)
                    self.userDefaultsWorker.setKakaoTalkId(id: stringId)
                    self.output.kakaoAccessToken.onNext(accessToken)
                    self.output.kakaoTalkId.onNext(stringId)
                    self.output.goToHome.accept(())
                }
            case .failure: ()
            }
        }
    }

    func logoutWithKakao() {
        print("📌logoutWithKakao")
        kakaoLoginWorker.logoutWithKakao()
        userDefaultsWorker.removeKakaoTalkId()
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
            print("📌appleId : \(userIdentifier)")
            print("📌familyName : \(fullName?.familyName ?? "")")
            print("📌givenName : \(fullName?.givenName ?? "")")
            print("📌email : \(email ?? "")")
            output.appleId.onNext(userIdentifier)
        default: break
        }
    }

}
