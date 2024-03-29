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
        view.backgroundColor = .background
        return view
    }()
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let navigationBarView = BaseNavigationBarView(title: "오리엔테이션")
    private let hStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 4
        return view
    }()
    private let markImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
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
		label.style(.Body1)
        label.text = "01.01"
        label.textAlignment = .right
        return label
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray_1000
		label.style(.H1)
        label.text = "오리엔테이션"
        label.numberOfLines = 0
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray_800
        label.style(.Body1)
        label.text = "새롭게 만난 팀원들과 함께 앞으로의 팀 방향성을 함께 생각해보아요! 새롭게 만난 팀원들과 인사도 나눠보고 즐거운 시간을 보내세요."
        label.numberOfLines = 0
		label.setLineSpacing(1.5)
        return label
    }()

    private let viewModel = HomeViewModel()
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
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
            $0.top.equalTo(view.snp.top).offset(44)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        contentView.addSubview(hStackView)
        hStackView.addArrangedSubviews([markImageView, attendanceLabel])
        hStackView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom).offset(42)
            $0.leading.equalToSuperview().offset(24)
        }
        markImageView.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.centerY.equalTo(hStackView.snp.centerY)
            $0.leading.equalTo(hStackView.snp.trailing)
            $0.trailing.equalToSuperview().offset(-24)
        }

        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(hStackView.snp.bottom).offset(28)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
        }
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
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

    func setType(_ session: Session, status: Status) {
        navigationBarView.titleLabel.text = "\(session.title)"
        titleLabel.text = session.title
        descriptionLabel.text = session.description
        dateLabel.text = session.date.date()?.mmdd() ?? ""
        switch session.type {
        case .needAttendance:
            guard let nowDate = Date().startDate() else { return }
            if Date().isPast(than: session.date.date()) {
                attendanceLabel.text = status.text
                attendanceLabel.textColor = status.textColor
                markImageView.image = status.image
                titleLabel.textColor = .gray_1200
                descriptionLabel.textColor = .gray_800
            } else {
                attendanceLabel.text = "예정"
                attendanceLabel.textColor = .gray_400
                markImageView.isHidden = true
            }
        case .dontNeedAttendance:
            attendanceLabel.text = "출석 체크 없는 날"
            attendanceLabel.textColor = .gray_400
            markImageView.isHidden = true
        case .dayOff:
            attendanceLabel.text = "쉬어가는 날"
            attendanceLabel.textColor = .gray_400
            markImageView.isHidden = true
        }
    }
}
