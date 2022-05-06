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

    private let dateLabel: UILabel = {
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

    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray_300
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension AdminTodayView {

    func updateUI(session: Session) {
        let date = session.date.date()?.mmdd()
        dateLabel.isHidden = false
        dateLabel.text = date
        titleLabel.text = session.title
        managementButton.isEnabled = session.type == .needAttendance
    }

    func updateUIWhenFinished() {
        dateLabel.isHidden = true
        titleLabel.text = "모든 세션을 끝마쳤습니다"
    }

}

// MARK: - UI
private extension AdminTodayView {

    func configureLayout() {
        addSubviews([dateLabel, stackView, dividerView])
        stackView.addArrangedSubviews([titleLabel, managementButton])

        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
        }
        stackView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(6)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(Constants.buttonSize.height)
        }
        managementButton.snp.makeConstraints {
            $0.width.equalTo(Constants.buttonSize.width)
        }
        dividerView.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.height.equalTo(1)
        }
    }

}
