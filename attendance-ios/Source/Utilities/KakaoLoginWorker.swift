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

}

// MARK: - User
extension KakaoLoginWorker {
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

    private func loginWithKakaoTalk(completion: @escaping (Result<String, Error>) -> Void) {
        UserApi.shared.rx.loginWithKakaoTalk()
            .subscribe(onNext: { oauthToken in
                completion(.success(oauthToken.accessToken))
            }, onError: { error in
                completion(.failure(error))
            }).disposed(by: disposeBag)
    }

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
