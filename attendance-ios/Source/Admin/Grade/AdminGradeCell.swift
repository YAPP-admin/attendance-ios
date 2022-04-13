//
//  AdminGradeCell.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/04/13.
//

import SnapKit
import UIKit

final class AdminGradeCell: UICollectionViewCell {

    enum Constants {
        static let horizontalPadding: CGFloat = 24
    }

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard(type: .regular, size: 16)
        label.textColor = .gray_800
        label.text = "김철수"
        return label
    }()

    private let gradeLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard(type: .semiBold, size: 16)
        label.textColor = .orange
        label.text = "100"
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

}

// MARK: - UI
private extension AdminGradeCell {

    func configureUI() {
        backgroundColor = .white
    }

    func configureLayout() {
        addSubviews([nameLabel, gradeLabel])

        nameLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(Constants.horizontalPadding)
            $0.centerY.equalToSuperview()
        }
//        gradeLabel.snp.makeConstraints {
//            $0.top.left.equalToSuperview()
//        }
    }

}
