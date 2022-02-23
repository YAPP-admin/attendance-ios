//
//  LoginViewController.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/01/31.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class LoginViewController: UIViewController {

    private let emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "간편하게 로그인하고\n간편하게 출석체크 해봐요"
        label.font = .systemFont(ofSize: 24, weight: .heavy)
        label.textColor = .black
        label.numberOfLines = 0
        label.setLineSpacing(6)
        return label
    }()

    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("카카오 로그인", for: .normal)
        button.backgroundColor = .yapp_kakao_yellow
        button.titleLabel?.font = .systemFont(ofSize: 19, weight: .regular)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()

    private let viewModel = BaseViewModel()
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        bindViewModel()
        addSubViews()
    }

}

private extension LoginViewController {

    func bindViewModel() {
        loginButton.rx.tap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .bind(to: viewModel.input.tapLogin)
            .disposed(by: disposeBag)

        viewModel.output.goToHome
            .observe(on: MainScheduler.instance)
            .bind(onNext: showHomeVC)
            .disposed(by: disposeBag)
    }

    func showHomeVC() {
        let homeVC = HomeViewController()
        homeVC.modalPresentationStyle = .fullScreen
        present(homeVC, animated: true, completion: nil)
    }

    func addSubViews() {
        view.addSubview(emptyView)
        view.addSubview(titleLabel)
        view.addSubview(loginButton)

        emptyView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(view.safeAreaLayoutGuide.snp.width)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(emptyView.snp.bottom).offset(23)
            $0.left.right.equalToSuperview().inset(24)
        }
        loginButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(57)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(45)
        }
    }

}
