//
//  SettingCellView.swift
//  attendance-ios
//
//  Created by 김보민 on 2022/03/31.
//

import SnapKit
import UIKit

final class SettingCellView: UIView {
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray_1200
        label.style(.Subhead1)
        return label
    }()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .trailing
        return stackView
    }()
    private let versionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray_600
        label.style(.Subhead1)
        return label
    }()
    private let rightButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cheron_right"), for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setVersionTypeButton(title: String, _ version: String) {
        titleLabel.text = title
        versionLabel.text = version
        versionLabel.isHidden = false
        rightButton.isHidden = true
    }

    func setPolicyTypeButton(title: String) {
        titleLabel.text = title
        versionLabel.isHidden = true
        rightButton.isHidden = false
    }

    func setLogout(_ title: String) {
        titleLabel.text = title
        titleLabel.textColor = .gray_400
        versionLabel.isHidden = true
        rightButton.isHidden = true
    }

    private func configureLayout() {
        addSubview(titleLabel)
        addSubview(stackView)
        stackView.addArrangedSubview(versionLabel)
        stackView.addArrangedSubview(rightButton)
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(24)
        }
        stackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
//            $0.leading.equalTo(titleLabel.snp.trailing)
            $0.trailing.equalToSuperview().offset(-24)
        }
    }
}
