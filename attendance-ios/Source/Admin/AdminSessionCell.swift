//
//  AdminSessionCell.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/04/01.
//

import SnapKit
import UIKit

final class AdminSessionCell: UICollectionViewCell {

    enum Constants {
        static let horizontalPadding: CGFloat = 24
        static let buttonWidth: CGFloat = 22
    }

    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        return stackView
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard(type: .regular, size: 16)
        label.textColor = .gray_1200
        label.text = "01.01      오리엔테이션"
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray_1200
        label.font = .Pretendard(type: .semiBold, size: 16)
//        label.text = "오리엔테이션"
        label.backgroundColor = .yellow
        return label
    }()

    private let arrowButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cheron_right"), for: .normal)
        button.tintColor = .gray_600
        button.imageView?.contentMode = .scaleAspectFit
        return button
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
private extension AdminSessionCell {

    func configureUI() {
        backgroundColor = .white
    }

    func configureLayout() {
        addSubviews([labelStackView, arrowButton])

        labelStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview().inset(Constants.horizontalPadding)
            $0.right.equalToSuperview().inset(50)
        }
        arrowButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(Constants.horizontalPadding)
            $0.width.height.equalTo(Constants.buttonWidth)
            $0.centerY.equalToSuperview()
        }

        labelStackView.addArrangedSubviews([dateLabel, titleLabel])
    }

}
