//
//  KakaoLoginWorker.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/04/14.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKUser
import RxCocoa
import RxKakaoSDKAuth
import RxKakaoSDKUser
import RxSwift

final class KakaoLoginWorker {

    private let disposeBag = DisposeBag()

    /// 카카오톡 유저 id를 반환합니다.
    func userId(completion: @escaping (Int64) -> Void) {
        UserApi.shared.me { user, _ in
            guard let userId = user?.id else { return }
            completion(userId)
        }
    }

}

// MARK: - Login
extension KakaoLoginWorker {

    func loginWithKakao(completion: @escaping (Result<String, Error>) -> Void) {
        if UserApi.isKakaoTalkLoginAvailable() {
            loginWithKakaoTalk { result in
                completion(result)
            }
        } else {
            loginWithKakaoAccount { result in
                completion(result)
            }
        }
    }

    /// 카카오톡 어플을 통해 로그인합니다.
    private func loginWithKakaoTalk(completion: @escaping (Result<String, Error>) -> Void) {
        UserApi.shared.rx.loginWithKakaoTalk()
            .subscribe(onNext: { oauthToken in
                completion(.success(oauthToken.accessToken))
            }, onError: { error in
                completion(.failure(error))
            }).disposed(by: disposeBag)
    }

    /// 카카오톡 어플이 없는 경우, 카카오톡 계정을 통해 로그인합니다.
    private func loginWithKakaoAccount(completion: @escaping (Result<String, Error>) -> Void) {
        UserApi.shared.rx.loginWithKakaoAccount()
            .subscribe(onNext: { oauthToken in
                completion(.success(oauthToken.accessToken))
            }, onError: { error in
                completion(.failure(error))
            }).disposed(by: disposeBag)
    }

}

// MARK: - Logout
extension KakaoLoginWorker {
  
  func logoutKakao(completion: @escaping (Error?) -> Void) {
    UserApi.shared.logout(completion: completion)
  }

    func logoutWithKakao() {
        UserApi.shared.rx.logout()
            .subscribe()
            .disposed(by: disposeBag)
    }

    func logoutWithKakao(completion: @escaping (Result<Void, Error>) -> Void) {
        UserApi.shared.rx.logout()
            .subscribe(onCompleted: {
                completion(.success(()))
            }, onError: {error in
                completion(.failure(error))
            }).disposed(by: disposeBag)
    }

}
