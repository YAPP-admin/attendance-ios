//
//  LoginViewController.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/01/31.
//

import AuthenticationServices
import Lottie
import RxCocoa
import RxSwift
import SnapKit
import UIKit

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
        button.setImage(UIImage(systemName: "applelogo"), for: .normal)
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

    private let guestLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Guest로 로그인", for: .normal)
        button.backgroundColor = .black
        button.tintColor = .white
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = .Pretendard(type: .regular, size: 19)
        button.layer.cornerRadius = Constants.cornerRadius
        button.isHidden = true
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

    private let mainSplashView = LottieAnimationView(name: "splash_main")
    private let loginSplashView = LottieAnimationView(name: "splash_main")

    private let viewModel = BaseViewModel()
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yapp_orange

        bindViewModel()
        bindSubviews()

        setupAppleLogin()
        setKeyboardObserver()

        setupFirstSpash()
        configureMainSplashView()
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
                guard let isValid = isValid else { return }
                self?.clearTextField()
                self?.setEasterEggView(isValid: isValid)
            })
            .disposed(by: disposeBag)

        viewModel.output.failedToLogin
            .observe(on: MainScheduler.instance)
            .bind(onNext: showToastWhenFailedToLogin)
            .disposed(by: disposeBag)

        viewModel.output.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                isLoading ? self?.showLoadingView() : self?.hideLoadingView()
            })
            .disposed(by: disposeBag)

        viewModel.output.shouldShowGuestButton
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] showButton in
                guard showButton == true else { return }
                self?.showGuestButton()
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

        guestLoginButton.rx.tap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .bind(to: viewModel.input.tapGuestLogin)
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
                self?.easterEggView.hideWrongMessage()
            }).disposed(by: disposeBag)
    }

}

private extension LoginViewController {

    func goToSignUpNameVC() {
        guard let kakaoTalkId = try? viewModel.output.kakaoTalkId.value(),
              let appleId = try? viewModel.output.appleId.value(),
              let isGuest = try? viewModel.output.isGuest.value() else { return }

        let signUpViewModel = SignUpViewModel()
        let signUpNameVC = SignUpNameViewController(viewModel: signUpViewModel)
        signUpViewModel.input.kakaoTalkId.onNext(kakaoTalkId)
        signUpViewModel.input.appleId.onNext(appleId)
        signUpViewModel.input.isGuest.onNext(isGuest)

        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.isHidden = true
        navigationController?.pushViewController(signUpNameVC, animated: true)
    }

    func goToHomeVC() {
        let homeVC = HomeViewController()
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.isHidden = true
        navigationController?.pushViewController(homeVC, animated: true)
    }

    func goToAdminVC() {
        let adminVC = AdminViewController()
        let navC = UINavigationController(rootViewController: adminVC)
        navC.modalPresentationStyle = .fullScreen
        self.present(navC, animated: true)
    }

}

// MARK: - Apple Login
extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {

    private func setupAppleLogin() {
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
    }

    private func loginWithApple() {
        viewModel.input.tapAppleLogin.accept(())
        authorizationController.performRequests()
    }

    func presentationAnchor(vc: UIViewController, for controller: ASAuthorizationController) -> ASPresentationAnchor {
        self.view.window!
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        viewModel.authorizationController(authorization: authorization)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        viewModel.output.isLoading.onNext(false)
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        self.view.window!
    }

}

// MARK: - Guest Login
extension LoginViewController {

    func showGuestButton() {
        guestLoginButton.isHidden = false
    }

}

// MARK: - Easter Egg
extension LoginViewController {

    func setEasterEggView(isValid: Bool) {
        if isValid == true {
            easterEggView.isHidden = true
        } else {
            easterEggView.showWrongMessage()
        }
    }

    func showEasterEgg() {
        easterEggView.isHidden = false
    }

    func clearTextField() {
        easterEggView.clearTextField()
    }

    func setKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            easterEggView.animateWhenKeyboardShow(with: keyboardHeight)
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        easterEggView.animateWhenKeyboardHide()
    }

}

// MARK: - Toast
extension LoginViewController {

    func showToastWhenFailedToLogin() {
        showToast(message: "로그인에 실패했습니다. 다시 시도해주세요.")
    }

}

// MARK: - UI
private extension LoginViewController {

    func setupFirstSpash() {
        guard let isFirst = try? viewModel.output.isFirstSplash.value(), isFirst == true else {
            view.backgroundColor = .background
            configureLayout()
            loginSplashView.play(fromFrame: 106, toFrame: 107)
            return
        }
        view.backgroundColor = .yapp_orange

        mainSplashView.play { [weak self] _ in
            self?.view.backgroundColor = .background
            self?.configureLayout()
            self?.viewModel.setupAfterSplashShowed()
        }
    }

    func configureMainSplashView() {
        view.addSubview(mainSplashView)

        mainSplashView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(120)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(view.bounds.width)
        }
    }

    func configureLayout() {
        view.addSubviews([loginSplashView, titleLabel, appleLoginButton, kakaoLoginButton, guestLoginButton])
        view.addSubviews([secretAdminButton, easterEggView])

        loginSplashView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(120)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(view.bounds.width)
        }
        titleLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(253)
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
        guestLoginButton.snp.makeConstraints {
            $0.top.equalTo(kakaoLoginButton.snp.bottom).offset(Constants.buttonSpacing)
            $0.left.right.equalToSuperview().inset(Constants.padding)
            $0.height.equalTo(Constants.buttonHeight)
        }

        secretAdminButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(120)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(view.bounds.width)
        }
        easterEggView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }

    }

}
