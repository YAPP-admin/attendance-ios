//
//  AdminTodayView.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/03/31.
//

import SnapKit
import UIKit

final class AdminTodayView: UIView {

    enum Constants {
        static let cornerRadius: CGFloat = 8
        static let buttonSize: CGSize = .init(width: 57, height: 33)
    }

    private let todayLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard(type: .regular, size: 14)
        label.textColor = .gray_600
        return label
    }()

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 4
        view.alignment = .fill
        view.distribution = .fill
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard(type: .semiBold, size: 18)
        label.textColor = .gray_1200
        return label
    }()

    let managementButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .yapp_orange
        button.setTitle("관리", for: .normal)
        button.titleLabel?.font = .Pretendard(type: .semiBold, size: 14)
        button.layer.cornerRadius = Constants.cornerRadius
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTodayLabel()
        configureTitleLabel()
        configureUI()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension AdminTodayView {

    func configureTodayLabel() {
        let todayString = "02.07"
        todayLabel.text = "\(todayString) 오늘"
    }

    func configureTitleLabel() {
        let titleString = "휴얍"
        titleLabel.text = titleString
    }

}

// MARK: - UI
private extension AdminTodayView {

    func configureUI() {
    }

    func configureLayout() {
        addSubviews([todayLabel, stackView])
        stackView.addArrangedSubviews([titleLabel, managementButton])

        todayLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
        }
        stackView.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.height.equalTo(Constants.buttonSize.height)
        }
        managementButton.snp.makeConstraints {
            $0.width.equalTo(Constants.buttonSize.width)
        }
    }

}
