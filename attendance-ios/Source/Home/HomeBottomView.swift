//
//  HomeBottomView.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/02/01.
//

import UIKit
import RxSwift
import SnapKit

protocol HomeBottomViewDelegate: AnyObject {
    func goToDetailVC()
}

final class HomeBottomView: UIView {
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "01/01"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.text = "1번째 세션"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "YAPP 오리엔테이션"
        label.font = .systemFont(ofSize: 24, weight: .heavy)
        label.textColor = .black
        return label
    }()
    
    private let summaryLabel: UILabel = {
        let label = UILabel()
        label.text = "팀원과 함께 모여서 앞으로의 방향성을\n논의하는 시간을 가져봐요!"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.setLineSpacing(3)
        return label
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("내 점수 00점     오늘 출석: 출석", for: .normal)
        button.backgroundColor = .gray
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    weak var delegate: HomeBottomViewDelegate?
    private let disposeBag = DisposeBag()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addTarget()
        configureView()
        addSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addTarget() {
        nextButton.rx.tap
            .bind { [weak self] _ in
                self?.delegate?.goToDetailVC()
            }.disposed(by: disposeBag)
    }
    
    private func configureView() {
        backgroundColor = .white
        layer.cornerRadius = 20
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func addSubViews() {
        addSubview(dateLabel)
        addSubview(numberLabel)
        addSubview(titleLabel)
        addSubview(summaryLabel)
        addSubview(nextButton)
        
        dateLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview().inset(24)
        }
        numberLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.left.equalTo(dateLabel.snp.right).offset(4)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(12)
            $0.left.equalToSuperview().inset(24)
        }
        summaryLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.left.equalToSuperview().inset(24)
        }
        nextButton.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(52)
        }
    }
}
