//
//  HomeViewController.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/01/31.
//

import AVFoundation
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class HomeViewController: UIViewController {
    private let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    private let settingButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "setting"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return button
    }()
    private lazy var tabView: HomeBottomTabView = {
        let view = HomeBottomTabView(viewModel.homeType.value)
        return view
    }()
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
    private let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.953, green: 0.961, blue: 0.973, alpha: 1)
        return view
    }()
    private let illustView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.image = UIImage(named: "illust_member_home_disabled")
        return view
    }()
    private let infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    private let infoStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 8
        return view
    }()
    private let checkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "info_check_disabled"), for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 출석 전이에요"
        label.style(.Body2)
        label.textColor = .gray_600
        return label
    }()
    private let contentsInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.style(.Body1)
        label.textColor = .gray_600
        return label
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.H1)
        label.textColor = .gray_1000
        label.numberOfLines = 0
        return label
    }()
    private let contentsLabel: UILabel = {
        let label = UILabel()
        label.style(.Body1)
        label.textColor = .gray_800
        label.numberOfLines = 0
        label.setLineSpacing(4)
        return label
    }()
    private let attendanceView = HomeAttendanceCheckViewController()

    private let viewModel = HomeViewModel()
    private var disposeBag = DisposeBag()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel.calculateScore()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        attendanceView.view.isHidden = true

        addSubViews()
        bind()
        updateSessionInfo()
    }

    func addSubViews() {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffectView.frame = view.frame

        view.addSubview(tabView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        view.addSubview(topView)
        topView.addSubview(visualEffectView)
        topView.addSubview(settingButton)
        topView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(88)
        }
        visualEffectView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        settingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-14)
            $0.bottom.equalToSuperview()
            $0.width.height.equalTo(44)
        }
        tabView.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.height.equalTo(100)
        }

        contentView.addSubview(bgView)
        bgView.addSubview(illustView)
        contentView.addSubview(infoView)
        infoView.addSubview(infoStackView)
        infoStackView.addArrangedSubview(checkButton)
        infoStackView.addArrangedSubview(infoLabel)
        contentView.addSubview(contentsInfoView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(tabView.snp.top)
        }
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.greaterThanOrEqualToSuperview()
        }
        bgView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(330)
        }
        illustView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(86)
        }
        infoView.snp.makeConstraints {
            $0.top.equalTo(illustView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(60)
        }
        infoStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        checkButton.snp.makeConstraints {
            $0.width.height.equalTo(20
            )
        }
        contentsInfoView.snp.makeConstraints {
            $0.top.equalTo(bgView.snp.bottom).offset(-20)
            $0.bottom.lessThanOrEqualToSuperview()
            $0.leading.trailing.equalToSuperview()
        }

        contentsInfoView.addSubview(dateLabel)
        contentsInfoView.addSubview(titleLabel)
        contentsInfoView.addSubview(contentsLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(28)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
        }
        contentsLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalToSuperview().offset(-40)
        }

        attendanceView.view.frame = self.view.frame
        view.addSubview(attendanceView.view)
        addChild(attendanceView)
        attendanceView.view.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(tabView.snp.top)
        }
    }

    func bind() {
        tabView.qrButton.rx.tap
            .bind(to: viewModel.input.tapQR)
            .disposed(by: disposeBag)

        viewModel.output.goToQR
            .observe(on: MainScheduler.instance)
            .bind(onNext: showQRVC)
            .disposed(by: disposeBag)

        settingButton.rx.tap
            .bind(to: viewModel.input.tapSetting)
            .disposed(by: disposeBag)

        viewModel.output.sessionList
            .subscribe(onNext: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.updateSessionInfo()
                }
            }).disposed(by: disposeBag)

        viewModel.output.goToSetting
            .observe(on: MainScheduler.instance)
            .bind(onNext: showSettingVC)
            .disposed(by: disposeBag)

        tabView.tapButton
            .subscribe(onNext: { [weak self] type in
                self?.viewModel.homeType.accept(type)
            }).disposed(by: disposeBag)

        viewModel.homeType
            .subscribe(onNext: { [weak self] type in
                switch type {
                case .todaySession:
                    self?.topView.isHidden = false
                    self?.scrollView.isHidden = false
                    self?.attendanceView.view.isHidden = true
                case .attendanceCheck:
                    self?.topView.isHidden = true
                    self?.scrollView.isHidden = true
                    self?.attendanceView.view.isHidden = false
                }
                self?.tabView.setHomeType(type)
            }).disposed(by: disposeBag)

        viewModel.memberData
            .subscribe(onNext: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.updateAttendancesData()
                }
            }).disposed(by: disposeBag)
    }

    func showQRVC() {
        let vc = QRViewController()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }

    func showSettingVC() {
        let vc = SettingViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func updateSessionInfo() {
        guard let session = viewModel.output.sessionList.value.todaySession() else { return }
        dateLabel.text = session.date.date()?.mmdd() ?? ""
        titleLabel.text = session.title
        contentsLabel.text = session.description
    }

    func updateAttendancesData() {
        guard let session = viewModel.output.sessionList.value.todaySession() else { return }
        if let data = viewModel.memberData.value {
            let id = data.attendances.filter { $0.sessionId == session.sessionId }.map { $0.sessionId }.first
            let text = data.attendances.filter { $0.sessionId == id }.map { $0.type.text }
            if text.first == "출석" {
                infoLabel.text = "출석을 완료했어요"
                infoLabel.textColor = .yapp_orange
                checkButton.setImage(UIImage(named: "info_check_enabled"), for: .normal)
                illustView.image = UIImage(named: "illust_member_home_enabled")
            } else {
                infoLabel.text = "아직 출석 전이에요"
                infoLabel.textColor = .gray_600
                checkButton.setImage(UIImage(named: "info_check_disabled"), for: .normal)
                illustView.image = UIImage(named: "illust_member_home_disabled")
            }
        }
    }
}
