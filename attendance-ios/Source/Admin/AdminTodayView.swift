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
        static let padding: CGFloat = 6
        static let cornerRadius: CGFloat = 8
    }

    private let todayLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard(type: .regular, size: 14)
        label.textColor = .gray_600
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard(type: .semiBold, size: 18)
        label.textColor = .gray_1200
        return label
    }()

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 0
        return view
    }()

    private let manageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .yapp_orange
        button.setTitle("관리", for: .normal)
        button.titleLabel?.font = .Pretendard(type: .regular, size: 14)
        button.backgroundColor = .yapp_orange
        button.layer.cornerRadius = Constants.cornerRadius
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTodayLabel()
        configureUI()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension AdminTodayView {

    // TODO: - 다음 세션 정보로 업데이트
    func configureTodayLabel() {
        let todayString = "02.07"
        todayLabel.text = "\(todayString) 오늘"
    }

    func configureTitleLabel() {
        let titleString = "YAPP 오리엔테이션"
        titleLabel.text = titleString
    }

}

private extension AdminTodayView {

    func configureUI() {
        backgroundColor = .gray_200
    }

    func configureLayout() {
        addSubviews([todayLabel, stackView])
        stackView.addSubviews([titleLabel, manageButton])

        todayLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
        }
        stackView.snp.makeConstraints {
            $0.top.equalTo(todayLabel.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview()
        }
    }

}
