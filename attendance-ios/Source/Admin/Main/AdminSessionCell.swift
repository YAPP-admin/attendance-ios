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
        label.textColor = .gray_400
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray_400
        label.font = .Pretendard(type: .semiBold, size: 16)
        return label
    }()

    private let arrowButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cheron_right"), for: .normal)
        button.tintColor = .gray_600
        button.imageView?.contentMode = .scaleAspectFit
        button.isHidden = true
        button.isUserInteractionEnabled = false
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

extension AdminSessionCell {

    func updateUI(with session: Session) {
        let date = session.date.date()?.mmdd()
        dateLabel.text = date
        titleLabel.text = session.title
        if session.type == .needAttendance {
            updateUIWhenNeedAttendance()
        } else {
            updateUIWhenDontNeedAttendance()
        }
    }

    private func updateUIWhenNeedAttendance() {
        dateLabel.textColor = .gray_1200
        titleLabel.textColor = .gray_1200
        arrowButton.isHidden = false
    }

    private func updateUIWhenDontNeedAttendance() {
        dateLabel.textColor = .gray_400
        titleLabel.textColor = .gray_400
        arrowButton.isHidden = true
    }
}

// MARK: - UI
private extension AdminSessionCell {

    func configureUI() {
        backgroundColor = .white
    }

    func configureLayout() {
        addSubviews([labelStackView, arrowButton])
        labelStackView.addArrangedSubviews([dateLabel, titleLabel])

        labelStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview().inset(Constants.horizontalPadding)
            $0.right.equalToSuperview().inset(50)
        }
        dateLabel.snp.makeConstraints {
            $0.width.equalTo(63)
        }
        arrowButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.right.equalToSuperview().inset(18)
			$0.height.equalTo(50)
			$0.centerY.equalToSuperview()
        }
    }

}
