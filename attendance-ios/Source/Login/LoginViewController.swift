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

    enum Constants {
        static let padding: CGFloat = 24
        static let buttonSpacing: CGFloat = 6
        static let cornerRadius: CGFloat = 12
    }

    private let emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "3초만에 끝나는\n간편한 출석체크"
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
        button.setImage(UIImage(systemName: "bubble.left.fill"), for: .normal)

        button.titleEdgeInsets = .init(top: 0, left: Constants.buttonSpacing/2, bottom: 0, right: -Constants.buttonSpacing/2)
        button.imageEdgeInsets = .init(top: 0, left: -Constants.buttonSpacing/2, bottom: 0, right: Constants.buttonSpacing/2)

        button.backgroundColor = .kakaoYellow
        button.tintColor = .black
        button.layer.cornerRadius = Constants.cornerRadius
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

        viewModel.output.goToLoginInfo
            .observe(on: MainScheduler.instance)
            .bind(onNext: goToLoginInfoVC)
            .disposed(by: disposeBag)

        viewModel.output.goToHome
            .observe(on: MainScheduler.instance)
            .bind(onNext: goToHomeVC)
            .disposed(by: disposeBag)
    }

    func goToLoginInfoVC() {
        let loginInfoVC = LoginInfoViewController()
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .black
        navigationController?.pushViewController(loginInfoVC, animated: true)
    }

    func goToHomeVC() {
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
            $0.top.equalTo(emptyView.snp.bottom).offset(Constants.padding)
            $0.left.right.equalToSuperview().inset(Constants.padding)
        }
        loginButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(57)
            $0.left.right.equalToSuperview().inset(Constants.padding)
            $0.height.equalTo(45)
        }
    }

}
