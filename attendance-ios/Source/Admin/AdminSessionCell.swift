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
        static let padding: CGFloat = 8
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        backgroundColor = .white
    }

    private func configureLayout() {

    }

}
