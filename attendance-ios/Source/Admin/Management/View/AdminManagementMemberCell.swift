//
//  AdminManagementMemberCell.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/05/05.
//

import SnapKit
import UIKit

final class AdminManagementMemberCell: BaseMemberCell {
    enum Constants {
        static let horizontalPadding: CGFloat = 28
        static let cornerRadius: CGFloat = 8
        static let buttonSize: CGSize = .init(width: 77, height: 36)
    }

    let attendanceButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray_200
        button.setTitle("출석", for: .normal)
        button.setTitleColor(UIColor.gray_800, for: .normal)
        button.titleLabel?.font = .Pretendard(type: .medium, size: 14)
        button.layer.cornerRadius = Constants.cornerRadius

        button.semanticContentAttribute = .forceLeftToRight
        let intervalSpacing = 7.5
        let halfIntervalSpacing = intervalSpacing / 2
        button.contentEdgeInsets = .init(top: 0, left: 11+halfIntervalSpacing, bottom: 0, right: 12+halfIntervalSpacing)
        button.imageEdgeInsets = .init(top: 0, left: -halfIntervalSpacing, bottom: 0, right: halfIntervalSpacing)
        button.titleEdgeInsets = .init(top: 0, left: halfIntervalSpacing, bottom: 0, right: -halfIntervalSpacing)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        addSubview(attendanceButton)
        attendanceButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(Constants.horizontalPadding)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(Constants.buttonSize.height)
        }
    }

}

extension AdminManagementMemberCell {
    func updateAttendance(with attendance: Attendance) {
        attendanceButton.setTitle(attendance.status.text, for: .normal)
        attendanceButton.setImage(attendance.status.image, for: .normal)
        attendanceButton.sizeToFit()
    }

}
