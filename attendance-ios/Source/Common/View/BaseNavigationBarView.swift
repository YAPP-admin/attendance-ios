//
//  BaseNavigationBarView.swift
//  attendance-ios
//
//  Created by 김보민 on 2022/04/28.
//

import Foundation
import RxSwift
import RxCocoa
import SnapKit
import UIKit

final class BaseNavigationBarView: UIView {
    let navigationBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
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
        return label
    }()

    init(title: String) {
        titleLabel.text = title
        super.init(frame: .zero)
        addSubViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubViews() {
        addSubview(navigationBarView)
        navigationBarView.addSubview(backButton)
        navigationBarView.addSubview(titleLabel)
        navigationBarView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.right.equalToSuperview().inset(44)
        }
        backButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(7)
            $0.width.height.equalTo(44)
        }
    }

    func hideBackButton() {
        backButton.isHidden = true
    }
}
