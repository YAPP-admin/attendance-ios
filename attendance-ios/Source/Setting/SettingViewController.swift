//
//  SettingViewController.swift
//  attendance-ios
//
//  Created by 김보민 on 2022/03/30.
//

import Foundation
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class SettingViewController: UIViewController {
    let navigationBarView = BaseNavigationBarView(title: "설정")
    let generationView: UIView = {
        let view = UIView()
        view.backgroundColor = .yapp_orange_opacity
        return view
    }()
    let generationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .yapp_orange
        label.style(.Body1)
        label.text = "YAPP 20기 회원"
        return label
    }()
    let illustView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.image = UIImage(named: "illust_profile")
        return view
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray_800
        label.style(.Body1)
        label.textAlignment = .center
        label.text = ""
        return label
    }()
    let sectionView: UIView = {
        let view = UIView()
        view.backgroundColor = .background_base
        return view
    }()
    let versionView: SettingCellView = {
        let view = SettingCellView()
        view.setVersionTypeButton(title: "버전 정보", "1.0.0")
        return view
    }()
    let policyView: SettingCellView = {
        let view = SettingCellView()
        view.setPolicyTypeButton(title: "개인정보 처리방침")
        return view
    }()
    let logoutView: SettingCellView = {
        let view = SettingCellView()
        view.setLogout("로그아웃")
        return view
    }()
    let memberoutView: SettingCellView = {
        let view = SettingCellView()
        view.setLogout("회원탈퇴")
        return view
    }()
    let alertView: AlertView = {
        let view = AlertView()
        view.isHidden = true
        view.configureUI(text: "정말 탈퇴하시겠어요?", subText: "탈퇴하면 모든 정보가 사라져요.", leftButtonText: "취소", rightButtonText: "탈퇴합니다")
        return view
    }()

    private let viewModel = SettingViewModel()
    private var disposeBag = DisposeBag()
    private let tapPolicy = UITapGestureRecognizer()
    private let tapLogout = UITapGestureRecognizer()
    private let tapMemberOut = UITapGestureRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        navigationController?.isNavigationBarHidden = true

        addSubViews()
        bind()
        bindSubViews()
        setRightSwipeRecognizer()
    }

    override func dismissWhenSwipeRight() {
        showHomeVC()
    }

    func bind() {
        navigationBarView.backButton.rx.tap
            .bind(to: viewModel.input.tapBack)
            .disposed(by: disposeBag)

        viewModel.output.goToHome
            .observe(on: MainScheduler.instance)
            .bind(onNext: showHomeVC)
            .disposed(by: disposeBag)

        viewModel.output.goToPolicyVC
            .observe(on: MainScheduler.instance)
            .bind(onNext: goToPolicyVC)
            .disposed(by: disposeBag)

        viewModel.output.goToLoginVC
            .observe(on: MainScheduler.instance)
            .bind(onNext: goToLoginVC)
            .disposed(by: disposeBag)

        viewModel.output.showDialogWhenMemberOut
            .observe(on: MainScheduler.instance)
            .bind(onNext: showDialogWhenMemberOut)
            .disposed(by: disposeBag)

        viewModel.output.showToastWhenError
            .observe(on: MainScheduler.instance)
            .bind(onNext: showToastWhenError)
            .disposed(by: disposeBag)

        viewModel.output.generation
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                if let num = self?.viewModel.output.generation.value {
                    self?.generationLabel.text = "YAPP " + num + "기 회원"
                }
            })
            .disposed(by: disposeBag)

        viewModel.output.name
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                if let name = self?.viewModel.output.name.value {
                    self?.nameLabel.text = name + " 님"
                }
            })
            .disposed(by: disposeBag)
    }

    func bindSubViews() {
        policyView.addGestureRecognizer(tapPolicy)
        logoutView.addGestureRecognizer(tapLogout)
        memberoutView.addGestureRecognizer(tapMemberOut)

        tapPolicy.rx.event
            .bind(onNext: { [weak self] _ in
                self?.viewModel.input.tapPolicyView.accept(())
            }).disposed(by: disposeBag)

        tapLogout.rx.event
            .bind(onNext: { [weak self] _ in
                self?.viewModel.input.tapLogoutView.accept(())
            }).disposed(by: disposeBag)

        tapMemberOut.rx.event
            .bind(onNext: { [weak self] _ in
                self?.viewModel.input.tapMemberView.accept(())
            }).disposed(by: disposeBag)

        alertView.rightButton.rx.controlEvent([.touchUpInside])
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.input.memberOut.accept(())
                self?.alertView.isHidden.toggle()
            }).disposed(by: disposeBag)
    }

    func showHomeVC() {
        self.navigationController?.popViewController(animated: true)
    }

    func goToPolicyVC() {
        let vc = SettingPrivacyPolicyViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func goToLoginVC() {
        let loginVC = LoginViewController()
        let navC = UINavigationController(rootViewController: loginVC)
        navC.modalPresentationStyle = .fullScreen
        self.present(navC, animated: true)
    }

    func showDialogWhenMemberOut() {
        alertView.isHidden = false
    }

    func showToastWhenError() {
        showToast(message: "오류가 발생했어요. 다시 시도해주세요.")
    }
}
