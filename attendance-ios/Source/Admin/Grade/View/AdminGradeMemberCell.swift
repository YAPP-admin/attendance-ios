//
//  AdminGradeMemberCell.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/05/05.
//

import SnapKit
import UIKit

final class AdminGradeMemberCell: BaseMemberCell {

    enum Constants {
        static let horizontalPadding: CGFloat = 28
    }

    private let nameStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 6
        return view
    }()

    private let iconImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "warning")
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        return view
    }()

    private let gradeLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard(type: .semiBold, size: 16)
        label.textColor = .orange
        label.text = "100"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureLayout() {
        addSubviews([nameStackView, gradeLabel])
        nameStackView.addArrangedSubviews([iconImageView, nameLabel, positionLabel])

        nameStackView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(Constants.horizontalPadding)
            $0.centerY.equalToSuperview()
        }
        gradeLabel.snp.makeConstraints {
            $0.right.equalToSuperview().inset(Constants.horizontalPadding)
            $0.centerY.equalToSuperview()
        }
    }
}

// MARK: - Update
extension AdminGradeMemberCell {

    func updateSubViews(with member: Member, sessionId: Int, sessionIdList: [Int]) {
        let attendances = member.attendances.filter { sessionIdList.contains($0.sessionId) && $0.sessionId < sessionId }
        var totalGrade = attendances.reduce(100, { $0 + $1.status.point })
        totalGrade = max(totalGrade, 0)

        gradeLabel.text = String(totalGrade)
        nameLabel.text = member.name
        positionLabel.text = member.position.shortValue
        
        if totalGrade < 70 {
            iconImageView.isHidden = false
        } else {
            iconImageView.isHidden = true
        }
    }

}
