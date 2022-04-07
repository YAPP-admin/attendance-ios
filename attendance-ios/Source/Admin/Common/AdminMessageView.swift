//
//  AdminMessageView.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/04/06.
//

import SnapKit
import UIKit

final class AdminMessageView: UIView {

    enum Constants {
        static let cornerRadius: CGFloat = 10
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard(type: .regular, size: 16)
        label.textColor = .yapp_orange
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

    func configureLabel(_ text: String) {
        titleLabel.text = text
    }

}

// MARK: - UI
private extension AdminMessageView {

    func configureUI() {
        backgroundColor = .yapp_orange_opacity
        layer.cornerRadius = Constants.cornerRadius
    }

    func configureLayout() {
        addSubview(titleLabel)

        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

}
