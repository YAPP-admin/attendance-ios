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

    private let todayLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard(type: .bold, size: 18)
        label.textColor = .gray_1200
        return label
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

    // TODO: - 다음 세션 날짜로 업데이트
    func configureTodayLabel() {
        let todayString = "02.07"
        todayLabel.text = "\(todayString) 오늘"
    }

}

private extension AdminTodayView {


    func configureUI() {
        backgroundColor = .gray_200
    }

    func configureLayout() {

    }

}
