//
//  AdminBottomSheetCell.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/04/14.
//

import SnapKit
import UIKit

final class AdminBottomSheetCell: UICollectionViewCell {

    enum Constants {
        static let horizontalPadding: CGFloat = 24
    }

    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        return stackView
    }()

    private let attendanceLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard(type: .semiBold, size: 16)
        label.textColor = .gray_1200
        label.textAlignment = .center
        label.text = "출석"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func didSelect() {
        backgroundColor = .gray_200
    }

    func didDeselect() {
        backgroundColor = .background
    }

    func updateLabel(_ attendance: String) {
        attendanceLabel.text = attendance
    }

}

// MARK: - UI
private extension AdminBottomSheetCell {

    func configureUI() {
        backgroundColor = .background
    }

    func configureLayout() {
        addSubviews([labelStackView])

        labelStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview()
        }

        labelStackView.addArrangedSubview(attendanceLabel)
    }

}
