//
//  HomeTotalScoreTableViewCell.swift
//  attendance-ios
//
//  Created by 김보민 on 2022/04/20.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class HomeTotalScoreTableViewCell: BaseTableViewCell {
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 0
        return view
    }()
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private let myscoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray_600
        label.style(.Body1)
        label.text = "지금 내 점수는"
        label.textAlignment = .center
        return label
    }()
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray_1000
        label.font = .Pretendard(type: .bold, size: 48)
        label.text = "90"
        label.textAlignment = .center
        return label
    }()
    private let sectionView: UIView = {
        let view = UIView()
        view.backgroundColor = .background_base
        return view
    }()
    private var progressbar = HalfCircleIndicator(frame: CGRect(x: UIScreen.main.bounds.midX, y: 100, width: UIScreen.main.bounds.width - 73 - 73, height: (UIScreen.main.bounds.width - 73 - 73) / 2), isInnerCircleExist: true, color: UIColor.red)
    private var backProgress = HalfCircleIndicator(frame: CGRect(x: UIScreen.main.bounds.midX, y: 100, width: UIScreen.main.bounds.width - 73 - 73, height: (UIScreen.main.bounds.width - 73 - 73) / 2), isInnerCircleExist: true, color: UIColor.gray_200)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initView() {
        progressbar.isInnerCircleExist = true
        backProgress.isInnerCircleExist = true
        progressbar.updateProgress(percent: 0.4)
        backProgress.updateProgress(percent: 1.0)
        backgroundColor = .clear
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        stackView.addArrangedSubview(containerView)
        containerView.addSubview(backProgress)
        backProgress.addSubview(progressbar)
        containerView.snp.makeConstraints {
            $0.height.equalTo(351)
        }
        backProgress.snp.makeConstraints {
            $0.top.equalToSuperview().offset(83)
            $0.leading.equalToSuperview().offset(73)
            $0.trailing.equalToSuperview().offset(-73)
            $0.height.equalTo(123)
        }
        progressbar.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        backProgress.addSubview(myscoreLabel)
        backProgress.addSubview(scoreLabel)
        myscoreLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        scoreLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        stackView.addArrangedSubview(sectionView)
        sectionView.snp.makeConstraints {
            $0.height.equalTo(12)
        }
    }
}
