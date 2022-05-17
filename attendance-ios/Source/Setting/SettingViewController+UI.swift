//
//  SettingViewController+UI.swift
//  attendance-ios
//
//  Created by 김보민 on 2022/03/30.
//

import Foundation
import RxCocoa
import RxSwift
import SnapKit
import UIKit

extension SettingViewController {
    func addSubViews() {
        view.addSubview(navigationBarView)
        navigationBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }

        view.addSubview(generationView)
        generationView.addSubview(generationLabel)
        generationView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        generationLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        view.addSubview(illustView)
        view.addSubview(nameLabel)
        illustView.snp.makeConstraints {
            $0.top.equalTo(generationView.snp.bottom).offset(28)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(113)
        }
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(illustView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
        }

        view.addSubview(sectionView)
        sectionView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(12)
        }

        view.addSubview(versionView)
        versionView.snp.makeConstraints {
            $0.top.equalTo(sectionView.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(59)
        }
        view.addSubview(policyView)
        policyView.snp.makeConstraints {
            $0.top.equalTo(versionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(59)
        }

        view.addSubview(logoutView)
        logoutView.snp.makeConstraints {
            $0.top.equalTo(policyView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(51)
        }
        view.addSubview(memberoutView)
        memberoutView.snp.makeConstraints {
            $0.top.equalTo(logoutView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(51)
        }

        view.addSubview(alertView)
        alertView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
    }
}
