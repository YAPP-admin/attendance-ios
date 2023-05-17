//
//  AttendanceSummaryView.swift
//  attendance-ios
//
//  Created by 김나희 on 5/16/23.
//

import UIKit

final class AttendanceStatusView: UIStackView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = TextStyle.Body2.font
        label.textColor = .gray_600
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = TextStyle.Subhead2.font
        label.textColor = .gray_1200
        return label
    }()
    
    init(title: String, count: Int = 0) {
        super.init(frame: .zero)
        setupLayout()
        setupData(title: title, count: count)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addArrangedSubviews([titleLabel, countLabel])
        axis = .horizontal
        spacing = 4
    }
    
    func setupData(title: String? = nil, count: Int) {
        if let title = title {
            titleLabel.text = title
        }
        
        countLabel.text = "\(count)명"
    }
}
