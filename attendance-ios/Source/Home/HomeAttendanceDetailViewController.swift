//
//  HomeAttendanceDetailViewController.swift
//  attendance-ios
//
//  Created by 김보민 on 2022/04/28.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class HomeAttendanceDetailViewController: UIViewController {
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let navigationBarView = BaseNavigationBarView(title: "오리엔테이션")
    private let markImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.image = UIImage(named: "attendance")
        return view
    }()
    private let attendanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .etc_green
        label.style(.Body1)
        label.text = "출석"
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray_600
        label.font = .Pretendard(type: .regular, size: 16)
        label.text = "01.01"
        label.textAlignment = .right
        return label
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray_1000
        label.font = .Pretendard(type: .bold, size: 24)
        label.text = "오리엔테이션"
        return label
    }()
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray_800
        label.style(.Body1)
        label.text = "새롭게 만난 팀원들과 함께 앞으로의 팀 방향성을 함께 생각해보아요! 새롭게 만난 팀원들과 인사도 나눠보고 즐거운 시간을 보내세요."
        label.numberOfLines = 0
        return label
    }()

    private let viewModel = HomeViewModel()
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true

        addSubViews()
        bind()
    }

    func addSubViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.leading.trailing.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.greaterThanOrEqualToSuperview()
        }
        contentView.addSubview(navigationBarView)
        navigationBarView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        contentView.addSubview(markImageView)
        markImageView.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.top.equalTo(navigationBarView.snp.bottom).offset(42)
            $0.leading.equalToSuperview().offset(24)
        }
        contentView.addSubview(attendanceLabel)
        attendanceLabel.snp.makeConstraints {
            $0.centerY.equalTo(markImageView.snp.centerY)
            $0.leading.equalTo(markImageView.snp.trailing).offset(4)
        }
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.centerY.equalTo(markImageView.snp.centerY)
            $0.leading.equalTo(attendanceLabel.snp.trailing)
            $0.trailing.equalToSuperview().offset(-24)
        }

        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(markImageView.snp.bottom).offset(28)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
        }
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
        }
    }

    func bind() {
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

    func setType(_ type: AttendanceType) {
        navigationBarView.titleLabel.text = "\(type.text)"
        updateUI(type)
    }

    private func updateUI(_ type: AttendanceType) {
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