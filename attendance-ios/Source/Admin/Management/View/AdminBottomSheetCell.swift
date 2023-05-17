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
        stackView.spacing = 7.5
        return stackView
    }()
    
    private let attendanceIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
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

    func updateCell(_ attendance: Status) {
        attendanceIconImageView.image = attendance.image
        attendanceLabel.text = attendance.text
    }

}

// MARK: - UI
private extension AdminBottomSheetCell {

    func configureUI() {
        backgroundColor = .background
    }

    func configureLayout() {
        addSubviews([labelStackView])
        labelStackView.addArrangedSubviews([attendanceIconImageView, attendanceLabel])

        labelStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        attendanceIconImageView.snp.makeConstraints {
            $0.width.height.equalTo(13)
        }
    }

}
