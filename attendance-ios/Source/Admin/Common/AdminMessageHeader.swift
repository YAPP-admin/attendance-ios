//
//  AdminMessageHeader.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/04/06.
//

import SnapKit
import UIKit

final class AdminMessageHeader: UICollectionReusableView {

    enum Constants {
        static let cornerRadius: CGFloat = 10
        static let verticalPadding: CGFloat = 28
        static let horizontalPadding: CGFloat = 24
        static let height: CGFloat = 48
    }

    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.cornerRadius
        view.backgroundColor = .yapp_orange_opacity
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard(type: .regular, size: 16)
        label.textAlignment = .center
        label.textColor = .yapp_orange
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
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
private extension AdminMessageHeader {

    func configureLayout() {
        addSubview(containerView)
        containerView.addSubview(titleLabel)

        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.right.equalToSuperview().inset(Constants.horizontalPadding)
            $0.height.equalTo(Constants.height)
        }
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }

}
