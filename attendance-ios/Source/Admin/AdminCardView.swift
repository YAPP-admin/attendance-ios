//
//  AdminCardView.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/03/16.
//

import SnapKit
import UIKit

final class AdminCardView: UIView {

    enum Constants {
        static let padding: CGFloat = 24
        static let cornerRadius: CGFloat = 12
    }

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.text = "20기 누적 출결 점수"
        label.font = .Pretendard(type: .bold, size: 18)
        label.textColor = .gray_1200
        return label
    }()

    private let subLabel: UILabel = {
        let label = UILabel()
        label.text = "누적 점수 확인하기"
        label.font = .Pretendard(type: .medium, size: 16)
        label.textColor = .yapp_orange
        return label
    }()

    private let imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "illust_manager_home")
        view.contentMode = .scaleAspectFit
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private extension AdminCardView {

    func configureUI() {
        backgroundColor = .gray_200
        layer.cornerRadius = Constants.cornerRadius
    }

    func configureLayout() {
        addSubviews([stackView, imageView])
        stackView.addArrangedSubviews([label, subLabel])

        stackView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview().inset(Constants.padding)
        }
        imageView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
    }

}
