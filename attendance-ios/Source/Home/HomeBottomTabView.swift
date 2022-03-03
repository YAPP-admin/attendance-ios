//
//  HomeBottomTabView.swift
//  attendance-ios
//
//  Created by 김보민 on 2022/03/03.
//

import Foundation
import RxSwift
import SnapKit
import UIKit

final class HomeBottomTabView: UIView {
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.91, green: 0.918, blue: 0.929, alpha: 1)
        return view
    }()

    private let leftStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
        return stackView
    }()

    private let leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "home_disabled")
        imageView.backgroundColor = .clear
        return imageView
    }()

    private let leftLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray_600
        // TODO: - font 정의 안되어있음
        label.font(.Caption1)
        label.text = "오늘 세션"
        label.textAlignment = .center
        return label
    }()

    private let rightStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
        return stackView
    }()

    private let rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "check_disabled")
        imageView.backgroundColor = .clear
        return imageView
    }()

    private let rightLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray_600
        // TODO: - font 정의 안되어있음
        label.font(.Caption1)
        label.text = "출결 확인"
        label.textAlignment = .center
        return label
    }()

    let qrButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .yapp_orange
        button.layer.cornerRadius = 56/2
        button.setImage(UIImage(named: "qr_button"), for: .normal)
        return button
    }()

    private let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubViews() {
        backgroundColor = .white
        addSubview(line)
        addSubview(qrButton)
        addSubview(leftStackView)
        leftStackView.addArrangedSubview(leftImageView)
        leftStackView.addArrangedSubview(leftLabel)
        addSubview(rightStackView)
        rightStackView.addArrangedSubview(rightImageView)
        rightStackView.addArrangedSubview(rightLabel)
        line.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(1
            )
        }
        qrButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-34)
            $0.width.height.equalTo(56)
        }
        leftStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.equalToSuperview().offset((UIScreen.main.bounds.width/3 - 37)/2)
            $0.bottom.lessThanOrEqualToSuperview()
        }
        rightStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.trailing.equalToSuperview().offset(-((UIScreen.main.bounds.width/3 - 37)/2))
            $0.bottom.lessThanOrEqualToSuperview()
        }
        leftImageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        rightImageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
    }
}
