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
        static let managementButtonSize: CGSize = .init(width: 60, height: 36)
    }

    private let dateLabel: UILabel = {
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
        addSubviews([dateLabel, titleLabel, managementButton, dividerView])

        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalTo(15)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(6)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview().inset(Constants.managementButtonSize.width+8)
            $0.height.equalTo(Constants.managementButtonSize.height)
        }
        managementButton.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(6)
            $0.right.equalToSuperview()
            $0.width.equalTo(Constants.managementButtonSize.width)
            $0.height.equalTo(Constants.managementButtonSize.height)
        }
        dividerView.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.height.equalTo(1)
        }
    }

}
