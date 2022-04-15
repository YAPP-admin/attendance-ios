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
        // TODO: - 테스트를 위해 추가, 이후 삭제
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
            return
        } else if let appleId = userDefaultsWorker.appleId(), appleId.isEmpty == false {
            print("📌appleId: \(appleId)")
            output.appleId.onNext(appleId)
            output.goToHome.accept(())
        } else {
            print("📌UserDefaults에 저장된 id가 없음")
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
                    let kakaoId = String(id)
                    self.output.kakaoAccessToken.onNext(accessToken)
                    self.output.kakaoTalkId.onNext(kakaoId)

                    print("📌카카오톡 로그인 시도중")

                    // TODO: - 애플 로그인 id값이 있으면 문서 수정하고 홈으로 이동
                    if let appleId = try? self.output.appleId.value() {
                        print("📌appleId: \(appleId)")

                        self.firebaseWorker.changeDocumentName(appleId, to: kakaoId) { result in
                            switch result {
                            case .success(let word): print("📌문서 불러오기: \(word)")
                            case .failure: print("📌문서 불러오기 실패")
                            }
                        }
                    }

                    // MARK: - 이미 가입한 카카오톡 유저인지 확인
                    self.firebaseWorker.checkIsRegisteredUser(id: kakaoId) { isRegistered in
                        guard isRegistered == true else {
                            print("📌가입하지 않은 카카오톡 유저 \(kakaoId)")
                            self.output.goToSignUp.accept(())
                            return
                        }
                        print("📌이미 가입한 카카오톡 유저")
                        self.userDefaultsWorker.setKakaoTalkId(id: kakaoId)
                        self.output.goToHome.accept(())

                    }
                }
            case .failure: ()
            }
        }
    }

    func checkIsRegisteredUser(id: String) {

    }

    func logoutWithKakao() {
        print("📌카카오톡 로그아웃")
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
//            let fullName = appleIDCredential.fullName
//            let email = appleIDCredential.email
            output.appleId.onNext(userIdentifier)
            self.firebaseWorker.checkIsRegisteredUser(id: userIdentifier) { isRegistered in
                guard isRegistered == true else {
                    print("📌가입하지 않은 애플 유저")
                    self.output.goToSignUp.accept(())
                    return
                }
                print("📌이미 가입한 애플 유저")
                self.userDefaultsWorker.setAppleId(id: userIdentifier)
                self.output.goToHome.accept(())
            }
        default: break
        }
    }

}
