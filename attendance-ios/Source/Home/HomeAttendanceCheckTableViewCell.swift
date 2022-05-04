//
//  HomeAttendanceCheckTableViewCell.swift
//  attendance-ios
//
//  Created by 김보민 on 2022/04/20.
//

import Foundation
import SnapKit
import UIKit

final class HomeAttendanceCheckTableViewCell: BaseTableViewCell {
    private let markImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.image = UIImage(named: "attendance")
        return view
    }()
    private let vStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 4
        view.alignment = .leading
        return view
    }()
    private let hStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 4
        view.distribution = .fill
        return view
    }()
    private let attendanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .etc_green
        label.font = .Pretendard(type: .regular, size: 14)
        label.text = "출석"
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray_400
        label.font = .Pretendard(type: .regular, size: 14)
        label.text = "01.01"
        label.textAlignment = .right
        return label
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray_1200
        label.font = .Pretendard(type: .bold, size: 18)
        label.text = "오리엔테이션"
        return label
    }()
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray_800
        label.font = .Pretendard(type: .regular, size: 16)
        label.text = "새롭게 만난 팀원들과 함께 앞으로의 팀 방향성을 함께 생각해보아요! 새롭게 만난 팀원들과 인사도 나눠보고 즐거운 시간을 보내세요."
        label.numberOfLines = 2
        return label
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
        contentView.addSubview(markImageView)
        markImageView.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.top.leading.equalToSuperview().offset(24)
        }
        contentView.addSubview(vStackView)
        vStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().offset(52)
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalToSuperview().offset(-24)
        }
        vStackView.addArrangedSubview(hStackView)
        hStackView.addArrangedSubview(attendanceLabel)
        hStackView.addArrangedSubview(dateLabel)
        vStackView.addArrangedSubview(titleLabel)
        vStackView.addArrangedSubview(contentLabel)
        hStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
    }

    func updateUI(_ type: AttendanceType) {
        if type.text == "출석" {
            attendanceLabel.text = "출석"
            attendanceLabel.textColor = .etc_green
            markImageView.image = UIImage(named: "attendance")
        } else if type.text == "지각" {
            attendanceLabel.text = "지각"
            attendanceLabel.textColor = .etc_yellow_font
            markImageView.image = UIImage(named: "tardy")
        } else if type.text == "결석" {
            attendanceLabel.text = "결석"
            attendanceLabel.textColor = .etc_red
            markImageView.image = UIImage(named: "absence")
        } else if type.text == "출석 인정" {
            attendanceLabel.text = "출석 인정"
            attendanceLabel.textColor = .etc_green
            markImageView.image = UIImage(named: "attendance")
        } else if type.text == "예정" {
            attendanceLabel.text = "예정"
            attendanceLabel.textColor = .gray_400
            markImageView.image = nil
        } else {
            attendanceLabel.text = "쉬어가는 날"
            attendanceLabel.textColor = .gray_400
            markImageView.image = nil
        }
    }
}
