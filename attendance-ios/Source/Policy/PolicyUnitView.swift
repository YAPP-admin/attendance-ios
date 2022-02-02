//
//  PolicyUnitView.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/02/02.
//

import UIKit
import SnapKit

final class PolicyUnitView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "사전 통보의 경우"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    private let gradeLabel: UILabel = {
        let label = UILabel()
        label.text = "시작점수: 100점"
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.backgroundColor = .systemGroupedBackground
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let tardyContainerView: UIView = {
        let view = UIView()
        return view
    }()

    private let absentContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let tardyLabel: UILabel = {
        let label = UILabel()
        label.text = "지각"
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private let tardyGradeLabel: UILabel = {
        let label = UILabel()
        label.text = "-5점"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .gray
        return label
    }()
    
    private let absentLabel: UILabel = {
        let label = UILabel()
        label.text = "결석"
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private let absentGradeLabel: UILabel = {
        let label = UILabel()
        label.text = "-15점"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .gray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI(title: String, tardyGrade: Int, absentGrade: Int) {
        titleLabel.text = "\(title)의 경우"
        titleLabel.setBoldFont(title)
        tardyGradeLabel.text = "\(tardyGrade)점"
        absentGradeLabel.text = "\(absentGrade)점"
    }
    
    private func addSubViews() {
        addSubview(titleLabel)
        addSubview(gradeLabel)
        addSubview(stackView)
        addSubview(dividerView)
        tardyContainerView.addSubview(tardyLabel)
        tardyContainerView.addSubview(tardyGradeLabel)
        absentContainerView.addSubview(absentLabel)
        absentContainerView.addSubview(absentGradeLabel)
        
        stackView.addArrangedSubview(tardyContainerView)
        stackView.addArrangedSubview(absentContainerView)
        
        titleLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview()
        }
        gradeLabel.snp.makeConstraints {
            $0.top.right.equalToSuperview()
            $0.bottom.equalTo(titleLabel.snp.bottom)
        }
        stackView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(100)
        }
        dividerView.snp.makeConstraints {
            $0.center.equalTo(stackView)
            $0.width.equalTo(1)
            $0.height.equalTo(80)
        }
        
        tardyLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(28)
        }
        tardyGradeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(tardyLabel.snp.bottom).offset(8)
        }
        absentLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(28)
        }
        absentGradeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(absentLabel.snp.bottom).offset(8)
        }
    }
}
