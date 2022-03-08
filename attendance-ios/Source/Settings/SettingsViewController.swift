//
//  SettingsViewController.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/03/08.
//

import KakaoSDKAuth
import KakaoSDKUser
import RxCocoa
import RxKakaoSDKAuth
import RxKakaoSDKUser
import RxSwift
import UIKit

final class SettingsViewController: UIViewController {

    enum Constants {
    }

    private let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindButton()
        configureUI()
        configureLayout()
    }

}

// MARK: - Bind
private extension SettingsViewController {

    //TODO: - 로그아웃
    func bindButton() {
        logoutButton.rx.controlEvent([.touchUpInside])
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.logoutWithKakao()
            }).disposed(by: disposeBag)
    }

}

// MARK: - etc
private extension SettingsViewController {

    func logoutWithKakao() {
        UserApi.shared.rx.logout()
            .subscribe(onCompleted: {
                print("로그아웃 성공")
            }, onError: {error in
                print(error)
            }).disposed(by: disposeBag)
    }

    func configureUI() {
        view.backgroundColor = .white
    }

    func configureLayout() {
        view.addSubview(logoutButton)

        logoutButton.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(100)
            $0.height.equalTo(51)
        }
    }

}
