//  LoginViewController.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/01/31.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit
import WebKit

final class LoginViewController: UIViewController {

    enum Constants {
        static let padding: CGFloat = 24
        static let buttonSpacing: CGFloat = 6
        static let cornerRadius: CGFloat = 12
        static let kakaoBlack: UIColor = UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1)
    }

    private let webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()

    private let splashView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "3초만에 끝나는\n간편한 출석체크"
        label.font = .Pretendard(type: .bold, size: 24)
        label.textColor = .gray_1200
        label.numberOfLines = 0
        label.setLineSpacing(4)
        return label
    }()

    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("카카오 로그인", for: .normal)
        button.backgroundColor = .yapp_kakao_yellow
        button.titleLabel?.font = .Pretendard(type: .medium, size: 19)
        button.setTitleColor(Constants.kakaoBlack, for: .normal)
        button.setImage(UIImage(systemName: "bubble.left.fill"), for: .normal)
        button.titleEdgeInsets = .init(top: 0, left: Constants.buttonSpacing/2, bottom: 0, right: -Constants.buttonSpacing/2)
        button.imageEdgeInsets = .init(top: 0, left: -Constants.buttonSpacing/2, bottom: 0, right: Constants.buttonSpacing/2)
        button.backgroundColor = .yapp_kakao_yellow
        button.tintColor = Constants.kakaoBlack
        button.layer.cornerRadius = Constants.cornerRadius
        return button
    }()

    private let secretAdminButton: UIButton = UIButton()

    private let viewModel = BaseViewModel()
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupDelegate()
        configureSplashView()
        configureWebView()
        configureUI()
        configureLayout()
    }

}

extension LoginViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webView == splashView {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.splashView.removeFromSuperview()
            }
        }
    }

}

private extension LoginViewController {

    func bindViewModel() {
        loginButton.rx.tap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .bind(to: viewModel.input.tapLogin)
            .disposed(by: disposeBag)

        secretAdminButton.rx.tap
            .bind { [weak self] _ in
                self?.goToAdminVC()
            }
            .disposed(by: disposeBag)

        viewModel.output.goToSignUp
            .observe(on: MainScheduler.instance)
            .bind(onNext: goToSignUpNameVC)
            .disposed(by: disposeBag)

        viewModel.output.goToHome
            .observe(on: MainScheduler.instance)
            .bind(onNext: goToHomeVC)
            .disposed(by: disposeBag)

        viewModel.output.goToAdmin
            .observe(on: MainScheduler.instance)
            .bind(onNext: goToAdminVC)
            .disposed(by: disposeBag)
    }

    func goToSignUpNameVC() {
        let signUpNameInfoVC = SignUpNameInfoViewController()
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .gray_800
        navigationController?.pushViewController(signUpNameInfoVC, animated: true)
    }

    func goToHomeVC() {
        let homeVC = HomeViewController()
        homeVC.modalPresentationStyle = .fullScreen
        present(homeVC, animated: true, completion: nil)
    }

    func goToAdminVC() {
        let adminVC = AdminViewController()
        adminVC.modalPresentationStyle = .fullScreen
        present(adminVC, animated: true, completion: nil)
    }

    func setupDelegate() {
        webView.navigationDelegate = self
        splashView.navigationDelegate = self
    }

    func configureWebView() {
        guard let filePath = Bundle.main.path(forResource: "bg_buong", ofType: "html"),
              let data = NSData(contentsOfFile: filePath),
              let html = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue) else { return }

        webView.loadHTMLString(html as String, baseURL: Bundle.main.bundleURL)
    }

    func configureSplashView() {
        guard let filePath = Bundle.main.path(forResource: "splash_login", ofType: "html"),
              let data = NSData(contentsOfFile: filePath),
              let html = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue) else { return }

        splashView.loadHTMLString(html as String, baseURL: Bundle.main.bundleURL)
    }

    func configureUI() {
        view.backgroundColor = .white
    }

    func configureLayout() {
        view.addSubview(titleLabel)
        view.addSubview(webView)
        view.addSubview(loginButton)
        view.addSubview(splashView)
        view.addSubview(secretAdminButton)

        webView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(80)
            $0.left.right.equalToSuperview().inset(68)
            $0.height.equalTo(view.bounds.width)
        }
        titleLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(180)
            $0.left.right.equalToSuperview().inset(Constants.padding)
        }
        loginButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(57)
            $0.left.right.equalToSuperview().inset(Constants.padding)
            $0.height.equalTo(45)
        }
        splashView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(40)
            $0.left.right.equalToSuperview().inset(10)
        }
        secretAdminButton.snp.makeConstraints {
            $0.top.left.equalTo(view.safeAreaLayoutGuide)
            $0.width.height.equalTo(20)
        }
    }

}
