//
//  AdminGradeMemberCell.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/05/05.
//

import SnapKit
import UIKit

final class AdminGradeMemberCell: UICollectionViewCell {

    enum Constants {
        static let horizontalPadding: CGFloat = 32
    }

    private let nameStackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .leading
        view.spacing = 8
        return view
    }()

    private let iconImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "warning")
        return view
    }()

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
private extension AdminGradeMemberCell {

    func configureUI() {
        backgroundColor = .white
    }

    func configureLayout() {
        addSubviews([nameStackView, gradeLabel])
        nameStackView.addArrangedSubviews([iconImageView, nameLabel])

        nameStackView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(Constants.horizontalPadding)
            $0.centerY.equalToSuperview()
        }
        gradeLabel.snp.makeConstraints {
            $0.right.equalToSuperview().inset(Constants.horizontalPadding)
            $0.centerY.equalToSuperview()
        }
    }

}