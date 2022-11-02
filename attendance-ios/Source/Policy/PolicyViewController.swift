//
//  PolicyViewController.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/02/02.
//

import SnapKit
import UIKit

final class PolicyViewController: UIViewController {

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "YAPP의 구성원은\n모든 세션에 필수적으로 참여해야 해요!"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 0
        label.setLineSpacing(4)
        return label
    }()

    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "지각과 결석 규칙에 대해 알려드릴게요"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .gray
        return label
    }()

    private lazy var policyNoticeView: PolicyUnitView = {
        let view = PolicyUnitView()
        view.configureUI(title: "사전 통보", tardyGrade: -5, absentGrade: -15)
        return view
    }()

    private lazy var policyNotNoticeView: PolicyUnitView = {
        let view = PolicyUnitView()
        view.configureUI(title: "미통보", tardyGrade: -10, absentGrade: -20)
        return view
    }()

    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "직장인 우대사항은 없어요\n점수가 70점 미만이 되는 회원은 운영진 심의 하에 제명될 수 있어요"
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        label.numberOfLines = 0
        label.setLineSpacing(4)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background

        configureNavigationBar()
        addSubViews()
    }

}

private extension PolicyViewController {

    func addSubViews() {
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(policyNoticeView)
        view.addSubview(policyNotNoticeView)
        view.addSubview(infoLabel)

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            $0.left.equalToSuperview().inset(24)
        }
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.left.equalToSuperview().inset(24)
        }
        policyNoticeView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(40)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(128)
        }
        policyNotNoticeView.snp.makeConstraints {
            $0.top.equalTo(policyNoticeView.snp.bottom).offset(40)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(128)
        }
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(policyNotNoticeView.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(24)
        }
    }

    func configureNavigationBar() {
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .black
    }

}
