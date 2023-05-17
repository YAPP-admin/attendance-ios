//
//  BaseMemberCell.swift
//  attendance-ios
//
//  Created by 김나희 on 5/18/23.
//

import UIKit
import SnapKit

class BaseMemberCell: UICollectionViewCell {
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard(type: .regular, size: 16)
        label.textColor = .gray_1000
        return label
    }()
    
    let positionLabel: UILabel = {
        let label = UILabel()
        label.font = TextStyle.Caption1.font
        label.textColor = .gray_600
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateSubViews(with member: Member) {
        nameLabel.text = member.name
        positionLabel.text = member.position.shortValue
    }
    
    func configureUI() {
        backgroundColor = .background
    }

    func configureLayout() {
        addSubviews([nameLabel, positionLabel])

        nameLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(28)
            $0.centerY.equalToSuperview()
        }
        positionLabel.snp.makeConstraints {
            $0.left.equalTo(nameLabel.snp.right).offset(6)
            $0.centerY.equalToSuperview()
        }
    }
}

