//
//  AdminManagementMemberCell.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/05/05.
//

import SnapKit
import UIKit

final class AdminManagementMemberCell: UICollectionViewCell {

    enum Constants {
        static let horizontalPadding: CGFloat = 24
        static let cornerRadius: CGFloat = 8
        static let buttonSize: CGSize = .init(width: 77, height: 33)
    }

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard(type: .regular, size: 16)
        label.textColor = .gray_800
        label.text = "김철수"
        return label
    }()

    let attendanceButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray_200
        button.setTitle("출석", for: .normal)
        button.setTitleColor(UIColor.gray_800, for: .normal)
        button.titleLabel?.font = .Pretendard(type: .semiBold, size: 14)
        button.layer.cornerRadius = Constants.cornerRadius

        button.setImage(UIImage(named: "arrowtriangle_down"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.titleEdgeInsets = .init(top: 0, left: -6, bottom: 0, right: -6)
        button.imageEdgeInsets = .init(top: 0, left: 6, bottom: 0, right: 0)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateSubViews(with member: Member) {
        nameLabel.text = member.name
    }

}

// MARK: - Update
extension AdminManagementMemberCell {

    func updateAttendance(with attendance: Attendance) {
        attendanceButton.setTitle(attendance.type.text, for: .normal)
    }

}

// MARK: - UI
private extension AdminManagementMemberCell {

    func configureUI() {
        backgroundColor = .white
    }

    func configureLayout() {
        addSubviews([nameLabel, attendanceButton])

        nameLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(Constants.horizontalPadding)
            $0.centerY.equalToSuperview()
        }
        attendanceButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(Constants.horizontalPadding)
            $0.centerY.equalToSuperview()
        }
        attendanceButton.snp.makeConstraints {
            $0.width.equalTo(Constants.buttonSize.width)
            $0.height.equalTo(Constants.buttonSize.height)
        }
    }

}
