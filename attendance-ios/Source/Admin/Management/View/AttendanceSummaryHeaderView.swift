//
//  AttendanceSummaryHeaderView.swift
//  attendance-ios
//
//  Created by 김나희 on 5/16/23.
//

import SnapKit
import UIKit

final class AttendanceSummaryHeaderView: UICollectionReusableView {
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor.gray_200.cgColor
        return view
    }()
    
    private let titleView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray_200
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = TextStyle.Body2.font
        return label
    }()
    
    private let lateView = AttendanceStatusView(title: "지각")
    private let absentView = AttendanceStatusView(title: "결석")
    private let admitView = AttendanceStatusView(title: "출석인정")
    
    private let attendanceInfoStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .equalSpacing
        stackView.layer.cornerRadius = 10
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        configureStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureData(_ members: [Member], sessionID: Int) {
        let attendances = members
            .flatMap { $0.attendances }
            .filter { $0.sessionId == sessionID }
        
        let presents = attendances.filter { $0.status != .absent }
        let lates = attendances.filter { $0.status == .late }
        let absents = attendances.filter { $0.status == .absent }
        let admits = attendances.filter { $0.status == .admit }
        
        configureTitleLabel(members, presents)
        lateView.setupData(count: lates.count)
        absentView.setupData(count: absents.count)
        admitView.setupData(count: admits.count)
    }
    
    func configureTitleLabel(_ members: [Member], _ attendances: [Attendance]) {
        let titleText = "\(members.count)명 중 \(attendances.count)명이 출석했어요"
        let attributeString = NSMutableAttributedString(string: titleText)
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.etc_green,
            .font: TextStyle.Subhead2.font
        ]
        attributeString.addAttributes(attributes, range: (titleText as NSString).range(of: "\(attendances.count)명"))
        titleLabel.attributedText = attributeString
    }
}

// MARK: - UI
private extension AttendanceSummaryHeaderView {
    func configureLayout() {
        addSubview(containerView)
        titleView.addSubview(titleLabel)
        containerView.addSubviews([titleView, attendanceInfoStackView])
        
        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(88)
        }
        
        titleView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        attendanceInfoStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(12)
        }
    }
    
    func configureStackView() {
        let attendanceStatusView = [lateView, absentView, admitView]
        for (index, view) in attendanceStatusView.enumerated() {
            attendanceInfoStackView.addArrangedSubview(view)
            if index < attendanceStatusView.count - 1 {
                let seperator = createSeparatorView()
                attendanceInfoStackView.addArrangedSubview(seperator)
                seperator.snp.makeConstraints {
                    $0.width.equalTo(1.5)
                    $0.height.equalTo(16)
                }
            }
        }
    }
    
    func createSeparatorView() -> UIView {
        let separator = UIView()
        separator.backgroundColor = .gray_200
        return separator
    }
}
