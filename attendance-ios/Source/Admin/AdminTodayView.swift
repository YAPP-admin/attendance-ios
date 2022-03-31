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
        static let padding: CGFloat = 24
        static let cornerRadius: CGFloat = 12
    }

    private let label: UILabel = {
        let label = UILabel()
        label.text = "02.07 오늘"
        label.font = .Pretendard(type: .Bold, size: 18)
        label.textColor = .gray_1200
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private extension AdminTodayView {

    func configureUI() {
        backgroundColor = .gray_200
    }

    func configureLayout() {

    }

}
