//
//  HomeChartView.swift
//  attendance-ios
//
//  Created by 김보민 on 2022/04/28.
//

import Foundation
import RxSwift
import RxCocoa
import SnapKit
import UIKit

final class HomeChartView: UIView {
    private let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .gray_200
        return stackView
    }()
    private let countStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .clear
        return stackView
    }()

    private let attendanceHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    private let attendanceImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "attendance")
        imageView.backgroundColor = .clear
        return imageView
    }()
    private let attendanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray_600
        label.font = .Pretendard(type: .medium, size: 14)
        label.text = "출석"
        return label
    }()
    var attendanceCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray_800
        label.font = .Pretendard(type: .semiBold, size: 18)
        label.text = "0"
        label.textAlignment = .center
        return label
    }()

    private let tardyHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    private let tardyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "tardy")
        imageView.backgroundColor = .clear
        return imageView
    }()
    private let tardyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray_600
        label.font = .Pretendard(type: .medium, size: 14)
        label.text = "지각"
        return label
    }()
    var tardyCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray_800
        label.font = .Pretendard(type: .semiBold, size: 18)
        label.text = "0"
        label.textAlignment = .center
        return label
    }()

    private let absenceHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    private let absenceImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "absence")
        imageView.backgroundColor = .clear
        return imageView
    }()
    private let absenceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray_600
        label.font = .Pretendard(type: .medium, size: 14)
        label.text = "결석"
        return label
    }()
    var absenceCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray_800
        label.font = .Pretendard(type: .semiBold, size: 18)
        label.text = "0"
        label.textAlignment = .center
        return label
    }()

    init() {
        super.init(frame: .zero)
        addSubViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubViews() {
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.gray_200.cgColor
        self.layer.borderWidth = 1.5
        self.clipsToBounds = true
        addSubview(topStackView)
        addSubview(countStackView)
        topStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }
        countStackView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        topStackView.addArrangedSubviews([attendanceHStackView, tardyHStackView, absenceHStackView])
        attendanceHStackView.addArrangedSubviews([attendanceImageView, attendanceLabel])
        tardyHStackView.addArrangedSubviews([tardyImageView, tardyLabel])
        absenceHStackView.addArrangedSubviews([absenceImageView, absenceLabel])
        attendanceImageView.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }
        tardyImageView.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }
        absenceImageView.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }
        countStackView.addArrangedSubviews([attendanceCountLabel, tardyCountLabel, absenceCountLabel])
    }
}
