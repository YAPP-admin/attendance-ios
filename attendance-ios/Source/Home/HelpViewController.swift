//
//  HelpViewController.swift
//  attendance-ios
//
//  Created by 김보민 on 2022/04/28.
//

import Foundation
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class HelpViewController: UIViewController {
    private let navigationBarView = BaseNavigationBarView(title: "도움말")
    private let titleLabel: UILabel = {
        let fullText = "YAPP의 구성원은\n모든 세션에 필수적으로 참여해야 해요!"
        let attributes: [NSAttributedString.Key: Any] = [.font: TextStyle.H3.font, .foregroundColor: UIColor.yapp_orange]
        let range = (fullText as NSString).range(of: "YAPP")
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttributes(attributes, range: range)

        let label = UILabel()
        label.textColor = .gray_1200
        label.style(.H3)
        label.attributedText = attributedString
        label.numberOfLines = 2
        return label
    }()
    private let descLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray_600
        label.style(.Body1)
        label.numberOfLines = 1
        label.text = "전체 세션만 출석 체크를 진행해요."
        return label
    }()
    private let chartView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.gray_200.cgColor
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        return view
    }()
    private let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .gray_200
        return stackView
    }()
    private let countStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .clear
        return stackView
    }()
    private let tardyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray_600
        label.font = .Pretendard(type: .regular, size: 14)
        label.text = "지각"
        label.textAlignment = .center
        return label
    }()
    private let absenceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray_600
        label.font = .Pretendard(type: .regular, size: 14)
        label.text = "결석"
        label.textAlignment = .center
        return label
    }()
    private let tardyScoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray_800
        label.font = .Pretendard(type: .semiBold, size: 18)
        label.text = "-10점"
        label.textAlignment = .center
        return label
    }()
    private let absenceScoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray_800
        label.font = .Pretendard(type: .semiBold, size: 18)
        label.text = "-20점"
        label.textAlignment = .center
        return label
    }()
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray_600
        label.style(.Body1)
        label.text = "* 운영진에게 요청 시 결석 1회는 출석으로 인정돼요."
        return label
    }()

    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray_200
        return view
    }()
    private let readLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray_800
        label.font = .Pretendard(type: .bold, size: 14)
        label.text = "읽어보세요!"
        return label
    }()
    private let readContentLabel: UILabel = {
        let fullText = "﹒ 출결 점수는 100점에서 시작해요.\n﹒ 점수가 70점 미만이 되는 회원은 운영진의 심의 하에 제명될 수 있으니 출결에 유의해주세요.\n﹒ 회비 납부 무단 연체 시 연체 1일마다 5점이 감점돼요.\n﹒ 아르바이트, 인턴, 직장인 우대사항은 없어요."
        let attributes: [NSAttributedString.Key: Any] = [.font: TextStyle.Caption2.font, .foregroundColor: UIColor.gray_800]
        let range100 = (fullText as NSString).range(of: "100점")
        let range70 = (fullText as NSString).range(of: "70점 미만")
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttributes(attributes, range: range100)
        attributedString.addAttributes(attributes, range: range70)

        let label = UILabel()
        label.textColor = .gray_600
        label.font = .Pretendard(type: .regular, size: 12)
        label.attributedText = attributedString
        label.numberOfLines = 0
        label.setLineSpacing(4)
        return label
    }()

    private let viewModel = HomeViewModel()
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubViews()
        bindView()
    }

    private func addSubViews() {
        view.addSubview(navigationBarView)
        navigationBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }

        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
        }
        view.addSubview(descLabel)
        descLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
        }
        setupChartView()
        setupBottomView()
    }

    private func setupChartView() {
        view.addSubview(chartView)
        chartView.snp.makeConstraints {
            $0.top.equalTo(descLabel.snp.bottom).offset(28)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(120)
        }
        chartView.addSubview(topStackView)
        chartView.addSubview(countStackView)
        topStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }
        countStackView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(80)
        }
        topStackView.addArrangedSubviews([tardyLabel, absenceLabel])
        countStackView.addArrangedSubviews([tardyScoreLabel, absenceScoreLabel])
        view.addSubview(commentLabel)
        commentLabel.snp.makeConstraints {
            $0.top.equalTo(chartView.snp.bottom).offset(28)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
        }
    }

    private func setupBottomView() {
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
            $0.height.equalTo(300)
        }
        bottomView.addSubview(readLabel)
        readLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
        }
        bottomView.addSubview(readContentLabel)
        readContentLabel.snp.makeConstraints {
            $0.top.equalTo(readLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.lessThanOrEqualToSuperview().offset(-128)
        }
    }

    private func bindView() {
        navigationBarView.backButton.rx.tap
            .bind(to: viewModel.input.tapBack)
            .disposed(by: disposeBag)

        viewModel.output.goToHome
            .observe(on: MainScheduler.instance)
            .bind(onNext: showHomeVC)
            .disposed(by: disposeBag)
    }

    func showHomeVC() {
        self.navigationController?.popViewController(animated: true)
    }
}
