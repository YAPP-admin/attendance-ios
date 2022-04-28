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
    private var progress = MKMagneticProgress()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
        setupProgress()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupProgress() {
        progress.setProgress(progress: 0.9, animated: true)
        progress.progressShapeColor = .etc_green
        progress.backgroundShapeColor = .gray_200
        progress.lineWidth = 10
        progress.orientation = .bottom
        progress.lineCap = .round
        progress.spaceDegree = 100
    }

    private func initView() {
        backgroundColor = .clear
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        stackView.addArrangedSubview(containerView)
        containerView.snp.makeConstraints {
            $0.height.equalTo(351)
        }
        containerView.addSubview(progress)
        progress.snp.makeConstraints {
            $0.top.equalToSuperview().offset(83 + 50)
            $0.leading.equalToSuperview().offset(73)
            $0.trailing.equalToSuperview().offset(-73)
            $0.height.equalTo(123)
        }
        containerView.addSubview(myscoreLabel)
        containerView.addSubview(scoreLabel)
        myscoreLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(83 + 30)
            $0.leading.equalToSuperview().offset(73)
            $0.trailing.equalToSuperview().offset(-73)
        }
        scoreLabel.snp.makeConstraints {
            $0.top.equalTo(myscoreLabel.snp.bottom)
            $0.leading.equalToSuperview().offset(73)
            $0.trailing.equalToSuperview().offset(-73)
        }
        stackView.addArrangedSubview(sectionView)
        sectionView.snp.makeConstraints {
            $0.height.equalTo(12)
        }
    }
}
