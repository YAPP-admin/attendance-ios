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
    let navigationBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    let backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "back"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return button
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray_1200
        label.font = .Pretendard(type: .regular, size: 18)
        label.text = "설정"
        return label
    }()
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

    private let viewModel = SettingViewModel()
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true

        addSubViews()
        bind()
    }

    func bind() {
        backButton.rx.tap
            .bind(to: viewModel.input.tapBack)
            .disposed(by: disposeBag)

        viewModel.output.goToHome
            .observe(on: MainScheduler.instance)
            .bind(onNext: showHomeVC)
            .disposed(by: disposeBag)

//        viewModel.memberData
//            .observe(on: MainScheduler.instance)
//            .subscribe(onNext: {[weak self] data in
//                if let data = data {
//                    self?.nameLabel.text = "\(data.name)님"
//                }
//            }).disposed(by: disposeBag)
    }

    func showHomeVC() {
        self.navigationController?.popViewController(animated: true)
    }
}
