//
//  SignUpCollectionViewCell.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/03/03.
//

import SnapKit
import UIKit

final class SignUpCollectionViewCell: UICollectionViewCell {

    private let jobLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard(type: .Medium, size: 16)
        label.textColor = .gray_800
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        configureUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureUI(text: String) {
        jobLabel.text = text
    }

    func configureSelectedUI() {
        jobLabel.textColor = UIColor.white
        backgroundColor = UIColor.yapp_orange
    }

    func configureDeselectedUI() {
        jobLabel.textColor = UIColor.gray_800
        backgroundColor = UIColor.gray_200
    }

    private func configureUI() {
        backgroundColor = .gray_200
        layer.cornerRadius = bounds.height/2
    }

    private func configureLayout() {
        addSubview(jobLabel)

        jobLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

}
