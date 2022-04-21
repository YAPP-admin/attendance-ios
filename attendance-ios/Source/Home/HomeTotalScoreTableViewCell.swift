//
//  HomeTotalScoreTableViewCell.swift
//  attendance-ios
//
//  Created by 김보민 on 2022/04/20.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class HomeTotalScoreTableViewCell: BaseTableViewCell {
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 100
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray_600
        label.style(.Body1)
        label.text = "지금 내 점수는"
        label.textAlignment = .center
        return label
    }()
    private let sectionView: UIView = {
        let view = UIView()
        view.backgroundColor = .background_base
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initView() {
        backgroundColor = .clear
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(sectionView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        sectionView.snp.makeConstraints {
            $0.height.equalTo(12)
        }
    }
}
