//
//  HomeMyScoreCollectionViewCell.swift
//  attendance-ios
//
//  Created by 김보민 on 2022/04/19.
//

import Foundation
import SnapKit
import UIKit

final class HomeMyScoreCollectionViewCell: UICollectionViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray_600
        label.style(.Body1)
        label.text = "지금 내 점수는"
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        backgroundColor = .clear
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
