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
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        return indicator
    }()
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
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
        view.backgroundColor = .background_base
        return view
    }()
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .background_base
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
        view.backgroundColor = .background
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
        view.backgroundColor = .background
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
    private let errorView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        view.isHidden = true
        return view
    }()
    private let errorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "illust_error")
        imageView.backgroundColor = .background
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "정보를 불러오지 못했어요"
        label.textColor = .gray_600
        label.font = .Pretendard(type: .semiBold, size: 18)
        return label
    }()

    private let viewModel = HomeViewModel()
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background_base
        navigationController?.isNavigationBarHidden = true
        attendanceView.view.isHidden = true
        setScrollViewDelegate()

        addSubViews()
        addErrorSubViews()
        bind()
        updateSessionInfo()
        setRefreshControl()
    }

    func addSubViews() {
        attendanceView.viewModel = self.viewModel
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffectView.frame = view.frame

        view.addSubviews([tabView, scrollView, topView])
        scrollView.addSubview(contentView)
        topView.addSubviews([visualEffectView, settingButton])

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
        infoStackView.addArrangedSubviews([checkButton, infoLabel])
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

        contentsInfoView.addSubviews([dateLabel, titleLabel, contentsLabel])
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

        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
    }

    func addErrorSubViews() {
        view.addSubview(errorView)
        errorView.addSubviews([errorImageView, errorLabel])

        errorView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.bottom.equalTo(tabView.snp.top)
            $0.left.right.equalToSuperview()
        }
        errorImageView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(67)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(172)
        }
        errorLabel.snp.makeConstraints {
            $0.top.equalTo(errorImageView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
    }

    func showErrorView() {
        errorView.isHidden = false
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
                    self?.viewModel.getUserData()
                case .attendanceCheck:
                    self?.topView.isHidden = true
                    self?.scrollView.isHidden = true
                    self?.attendanceView.view.isHidden = false
                    self?.viewModel.getUserData()
                }
                self?.tabView.setHomeType(type)
            }).disposed(by: disposeBag)

		viewModel.output.isReload
			.subscribe(onNext: { [weak self] isReload in
				guard isReload == true else { return }
				DispatchQueue.main.async {
					self?.attendanceView.tableView.reloadData()
				}
			}).disposed(by: disposeBag)

        viewModel.memberData
            .subscribe(onNext: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.updateAttendancesData()
                }
            }).disposed(by: disposeBag)

        viewModel.isRefreshing
            .subscribe(onNext: { [weak self] isRefreshing in
                guard isRefreshing == false else {
                    self?.activityIndicator.startAnimating()
                    return
                }
                DispatchQueue.main.async {
                    self?.scrollView.refreshControl?.endRefreshing()
                }
            }).disposed(by: disposeBag)

        viewModel.output.hasError
            .subscribe(onNext: { [weak self] hasError in
                guard hasError == true else { return }
                DispatchQueue.main.async {
                    self?.showErrorView()
                }
            }).disposed(by: disposeBag)
    }

    func showQRVC() {
		let format = DateFormatter()
		format.dateFormat = "yyyy-MM-dd HH:mm:ss"
		format.locale = Locale(identifier: "ko_KR")
		format.timeZone = TimeZone(abbreviation: "KST")

		guard let time = getKoreaDateTypeToString(),
              let session = viewModel.output.sessionList.value.todaySession(),
              let startTime = format.date(from: time),
              let endTime = format.date(from: session.date) else {
            showToastWhenCannotAttend()
            return
        }

		let useTime = Int(endTime.timeIntervalSince(startTime)).magnitude
      if time.stringPrefix(endNum: -10) == session.date.stringPrefix(endNum: -10), session.type == .needAttendance, viewModel.currentType.value == .absent {
			let vc = QRViewController()
            vc.delegate = self
			vc.modalPresentationStyle = .overFullScreen
			vc.viewModel.output.memberData.onNext(self.viewModel.memberData.value)
			vc.updateHomeData = { data in
				if data { self.viewModel.getUserData() }
			}
			if useTime <= 300 {
        vc.viewModel.output.currentType.accept(.normal)
				self.present(vc, animated: true, completion: nil)
			} else if useTime > 300, useTime <= 1800, time.stringPrefix(endNum: -7) == session.date.stringPrefix(endNum: -7) {
        vc.viewModel.output.currentType.accept(.late)
				self.present(vc, animated: true, completion: nil)
			} else {
                showToastWhenCannotAttend()
			}
      } else if session.type == .needAttendance, viewModel.currentType.value == .normal {
            showToastWhenAlreadyAttended()
		} else if viewModel.isGuest.value == true {
			let vc = QRViewController()
            vc.delegate = self
			vc.modalPresentationStyle = .overFullScreen
			vc.viewModel.output.memberData.onNext(self.viewModel.memberData.value)
			vc.viewModel.output.isPass.accept(true)
			vc.updateHomeData = { data in
				if data { self.viewModel.getUserData() }
			}
      vc.viewModel.output.currentType.accept(.normal)
			self.present(vc, animated: true, completion: nil)
		} else {
            showToastWhenCannotAttend()
		}
	}

    func showToastWhenCannotAttend() {
        showToast(message: "지금은 출석할 수 없어요.")
    }

    func showToastWhenAlreadyAttended() {
        showToast(message: "이미 출석을 완료했어요.")
    }

	func getKoreaDateTypeToString() -> String? {
		let current = Date()
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier: "ko_KR")
		formatter.timeZone = TimeZone(abbreviation: "KST")
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		return formatter.string(from: current)
	}

    func showSettingVC() {
        let vc = SettingViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func updateSessionInfo() {
        guard let session = viewModel.output.sessionList.value.todaySession() else {
            updateWhenAllSessionsCompleted()
            return
        }

        dateLabel.text = session.date.date()?.mmdd() ?? ""
        titleLabel.text = session.title
        contentsLabel.text = session.description
    }

    func updateWhenAllSessionsCompleted() {
        dateLabel.text = ""
        titleLabel.text = "모든 세션을 끝마쳤습니다"
        contentsLabel.text = ""
    }

    func updateAttendancesData() {
        guard let session = viewModel.output.sessionList.value.todaySession() else { return }
        if let data = viewModel.memberData.value {
            let id = data.attendances.filter { $0.sessionId == session.sessionId }.map { $0.sessionId }.first
            let text = data.attendances.filter { $0.sessionId == id }.map { $0.status.text }
			if session.type == .dayOff {
                updateUIWhenAttendance()
			} else {
				if text.first == "결석" {
					infoLabel.text = "아직 출석 전이에요"
					infoLabel.textColor = .gray_600
					checkButton.setImage(UIImage(named: "info_check_disabled"), for: .normal)
					illustView.image = UIImage(named: "illust_member_home_disabled")
                    viewModel.currentType.accept(.absent)
				} else {
					infoLabel.text = "출석을 완료했어요"
					infoLabel.textColor = .yapp_orange
					checkButton.setImage(UIImage(named: "info_check_enabled"), for: .normal)
					illustView.image = UIImage(named: "illust_member_home_enabled")
					viewModel.currentType.accept(.normal)
				}
			}
        }
    }

    func updateUIWhenAttendance() {
        infoLabel.text = "출석을 완료했어요"
        infoLabel.textColor = .yapp_orange
        checkButton.setImage(UIImage(named: "info_check_enabled"), for: .normal)
        illustView.image = UIImage(named: "illust_member_home_enabled")
        viewModel.currentType.accept(.normal)
    }

}

// MARK: - Refresh Control
private extension HomeViewController {

    func setRefreshControl() {
        scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }

    @objc func refresh() {
        viewModel.isRefreshing.accept(true)
    }

}

extension HomeViewController: UIScrollViewDelegate {

    private func setScrollViewDelegate() {
        scrollView.delegate = self
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        activityIndicator.stopAnimating()
    }
}

extension HomeViewController: QRLoginDelegate {

    func loggedIn() {
        updateUIWhenAttendance()
    }

}
