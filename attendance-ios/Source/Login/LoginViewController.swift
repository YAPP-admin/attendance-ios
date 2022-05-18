//  LoginViewController.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/01/31.
//

import AuthenticationServices
import RxCocoa
import RxSwift
import SnapKit
import UIKit
import WebKit

final class LoginViewController: UIViewController {

    enum Constants {
        static let padding: CGFloat = 24
        static let leftButtonHalfWidth: CGFloat = 3
        static let buttonSpacing: CGFloat = 8
        static let buttonHeight: CGFloat = 44
        static let buttonBottomSpacing: CGFloat = 133
        static let cornerRadius: CGFloat = 12
        static let kakaoBlack: UIColor = UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1)
    }

    private let mainSplashView: WKWebView = {
        let webView = WKWebView()
        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
        webView.scrollView.backgroundColor = UIColor.clear
        return webView
    }()

    private let splashBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .yapp_orange
        view.isHidden = true
        return view
    }()

    private let loginSplashView: WKWebView = {
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

    private let appleLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Apple로 로그인", for: .normal)
        button.backgroundColor = .black
        button.tintColor = .white
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = .Pretendard(type: .regular, size: 19)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setImage(UIImage(systemName: "applelogo"), for: .normal) // 이미지 수정
        button.titleEdgeInsets = .init(top: 0, left: Constants.leftButtonHalfWidth, bottom: 0, right: -Constants.leftButtonHalfWidth)
        button.imageEdgeInsets = .init(top: 0, left: -Constants.leftButtonHalfWidth, bottom: 0, right: Constants.leftButtonHalfWidth)
        button.layer.cornerRadius = Constants.cornerRadius
        return button
    }()

    private let kakaoLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("카카오 로그인", for: .normal)
        button.backgroundColor = .yapp_kakao_yellow
        button.tintColor = Constants.kakaoBlack
        button.setTitleColor(Constants.kakaoBlack, for: .normal)
        button.titleLabel?.font = .Pretendard(type: .regular, size: 19)
        button.setImage(UIImage(named: "kakao_login"), for: .normal)
        button.titleEdgeInsets = .init(top: 0, left: Constants.leftButtonHalfWidth, bottom: 0, right: -Constants.leftButtonHalfWidth)
        button.imageEdgeInsets = .init(top: 0, left: -Constants.leftButtonHalfWidth, bottom: 0, right: Constants.leftButtonHalfWidth)
        button.layer.cornerRadius = Constants.cornerRadius
        return button
    }()

    private let secretAdminButton: UIButton = UIButton()

    private let easterEggView: EasterEggView = {
        let view = EasterEggView()
        view.isHidden = true
        return view
    }()

    private let authorizationController: ASAuthorizationController = {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        return authorizationController
    }()

    private let viewModel = BaseViewModel()
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        bindSubviews()

        setupAppleLogin()
        setupDelegate()

        setupLoginSplashView()
        setupMainSplashView()
        configureUI()
        configureLayout()
    }

}

// MARK: - Bind
private extension LoginViewController {

    func bindViewModel() {
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

        viewModel.output.showEasterEgg
            .observe(on: MainScheduler.instance)
            .bind(onNext: showEasterEgg)
            .disposed(by: disposeBag)

        viewModel.output.isEasterEggKeyValid
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isValid in
                self?.clearTextField()
                if isValid == true {
                    self?.easterEggView.isHidden = true
                }
            })
            .disposed(by: disposeBag)
    }

    func bindSubviews() {
        appleLoginButton.rx.tap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .bind(onNext: loginWithApple)
            .disposed(by: disposeBag)

        kakaoLoginButton.rx.tap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .bind(to: viewModel.input.tapKakaoTalkLogin)
            .disposed(by: disposeBag)

        secretAdminButton.rx.tap
            .bind(to: viewModel.input.tapEasterEgg)
            .disposed(by: disposeBag)

        easterEggView.rightButton.rx.tap
            .bind(to: viewModel.input.tapEasterEggOkButton)
            .disposed(by: disposeBag)

        easterEggView.textField.rx.text
            .subscribe(onNext: { [weak self] text in
                guard let text = text else { return }
                self?.viewModel.input.easterEggKey.onNext(text)
            }).disposed(by: disposeBag)
    }

}

private extension LoginViewController {

    func goToSignUpNameVC() {
        guard let kakaoTalkId = try? viewModel.output.kakaoTalkId.value(), let appleId = try? viewModel.output.appleId.value() else { return }

        let signUpViewModel = SignUpViewModel()
        let signUpNameVC = SignUpNameViewController(viewModel: signUpViewModel)
        signUpViewModel.input.kakaoTalkId.onNext(kakaoTalkId)
        signUpViewModel.input.appleId.onNext(appleId)

        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .gray_800
        navigationController?.pushViewController(signUpNameVC, animated: true)
    }

    func goToHomeVC() {
        let homeVC = HomeViewController()
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .gray_800
        navigationController?.pushViewController(homeVC, animated: true)
    }

    func goToAdminVC() {
        let adminVC = AdminViewController()
        let navC = UINavigationController(rootViewController: adminVC)
        navC.modalPresentationStyle = .fullScreen
        self.present(navC, animated: true)
    }

    func setupDelegate() {
        mainSplashView.navigationDelegate = self
        loginSplashView.navigationDelegate = self
    }

}

// MARK: - Apple Login
extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {

    func setupAppleLogin() {
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
    }

    func loginWithApple() {
        authorizationController.performRequests()
    }

    func presentationAnchor(vc: UIViewController, for controller: ASAuthorizationController) -> ASPresentationAnchor {
        self.view.window!
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        viewModel.authorizationController(authorization: authorization)
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        self.view.window!
    }

}

// MARK: - Splash
extension LoginViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let userDefaultsWorker = UserDefaultsWorker()
        let isFirstSplash = userDefaultsWorker.getIsFirstSplash()

        guard isFirstSplash == false else {
            removeSplashView()
            return
        }
        showSplashBackgroundView()

        if webView == loginSplashView {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.hideSplashBackgroundView()
                self.removeSplashView()
                self.viewModel.checkKakaoId()
                userDefaultsWorker.setIsFirstSplash(isFirst: true)
            }
        }
    }

    private func showSplashBackgroundView() {
        splashBackgroundView.isHidden = false
    }

    private func hideSplashBackgroundView() {
        splashBackgroundView.isHidden = true
    }

    private func removeSplashView() {
        self.loginSplashView.removeFromSuperview()
        self.splashBackgroundView.removeFromSuperview()
    }

}

// MARK: - Easter Egg
extension LoginViewController {

    func showEasterEgg() {
        easterEggView.isHidden = false
    }

    func clearTextField() {
        easterEggView.clearTextField()
    }

}

// MARK: - UI
private extension LoginViewController {

    func setupLoginSplashView() {
        guard let filePath = Bundle.main.path(forResource: "splash_login", ofType: "html"),
              let data = NSData(contentsOfFile: filePath),
              let html = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue) else { return }

        loginSplashView.loadHTMLString(html as String, baseURL: Bundle.main.bundleURL)
    }

    func setupMainSplashView() {
        guard let filePath = Bundle.main.path(forResource: "splash_main", ofType: "html"),
              let data = NSData(contentsOfFile: filePath),
              let html = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue) else { return }

        mainSplashView.loadHTMLString(html as String, baseURL: Bundle.main.bundleURL)
    }

    func configureUI() {
        view.backgroundColor = .white
    }

    func configureLayout() {
        view.addSubviews([titleLabel, appleLoginButton, kakaoLoginButton, secretAdminButton, easterEggView])
        view.addSubviews([mainSplashView, splashBackgroundView, loginSplashView])

        loginSplashView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.bottom.equalToSuperview().inset(80)
            $0.left.right.equalToSuperview().inset(10)
        }
        splashBackgroundView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
        mainSplashView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.left.right.equalToSuperview().inset(68)
            $0.height.equalTo(view.bounds.width)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(mainSplashView.snp.bottom)
            $0.left.right.equalToSuperview().inset(Constants.padding)
        }
        appleLoginButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(Constants.buttonBottomSpacing)
            $0.left.right.equalToSuperview().inset(Constants.padding)
            $0.height.equalTo(Constants.buttonHeight)
        }
        kakaoLoginButton.snp.makeConstraints {
            $0.top.equalTo(appleLoginButton.snp.bottom).offset(Constants.buttonSpacing)
            $0.left.right.equalToSuperview().inset(Constants.padding)
            $0.height.equalTo(Constants.buttonHeight)
        }
        secretAdminButton.snp.makeConstraints {
            $0.center.equalTo(mainSplashView)
            $0.width.height.equalTo(200)
        }
        easterEggView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
    }

}
