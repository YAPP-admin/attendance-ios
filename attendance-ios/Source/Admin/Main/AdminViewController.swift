//
//  AdminViewController.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/03/16.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class AdminViewController: UIViewController {

    enum Constants {
        static let verticalPadding: CGFloat = 28
        static let horizontalPadding: CGFloat = 24
        static let topPadding: CGFloat = 88
        static let dividerViewHeight: CGFloat = 12
        static let todayViewHeight: CGFloat = 80
        static let cellHeight: CGFloat = 60
    }

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "출결 관리"
        label.font = .Pretendard(type: .bold, size: 24)
        label.textColor = .gray_1200
        label.numberOfLines = 0
        return label
    }()

    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .background_base
        return view
    }()

    private let cardView = AdminCardView()
    private let todayView = AdminTodayView()

    private let sessionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "전체 보기"
        label.font = .Pretendard(type: .medium, size: 14)
        label.textColor = .gray_600
        label.numberOfLines = 0
        return label
    }()

    private let sessionCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    private let viewModel = AdminViewModel()
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        bindSubviews()

        setupCollectionView()

        configureUI()
        configureLayout()
        addNavigationLogoutButton()
    }

    override func navigationLogoutButtonTapped() {
        viewModel.input.tapLogoutButton.accept(())
    }

}

// MARK: - Bind
private extension AdminViewController {

    func bindViewModel() {
        viewModel.output.isFinished
            .subscribe(onNext: { [weak self] isFinished in
                guard isFinished == true else { return }
                DispatchQueue.main.async {
                    self?.todayView.updateUIWhenFinished()
                }
            }).disposed(by: disposeBag)

        viewModel.output.sessionList
            .subscribe(onNext: { [weak self] list in
                DispatchQueue.main.async {
                    self?.updateCollectionViewHeight(with: list)
                    self?.reloadCollectionView()
                }
            }).disposed(by: disposeBag)

        viewModel.output.todaySession
            .subscribe(onNext: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.updateTodayView()
                }
            }).disposed(by: disposeBag)

        viewModel.output.goToGradeVC
            .observe(on: MainScheduler.instance)
            .bind(onNext: goToGradeVC)
            .disposed(by: disposeBag)

        viewModel.output.goToLoginVC
            .observe(on: MainScheduler.instance)
            .bind(onNext: goToLoginVC)
            .disposed(by: disposeBag)
    }

    func bindSubviews() {
        let tapGesture = UITapGestureRecognizer()
        cardView.addGestureRecognizer(tapGesture)

        tapGesture.rx.event
            .bind(onNext: { [weak self] _ in
                self?.viewModel.input.tapCardView.accept(())
            }).disposed(by: disposeBag)

        todayView.managementButton.rx.controlEvent([.touchUpInside])
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.goToTodayManagementVC()
            }).disposed(by: disposeBag)
    }

}

// MARK: - CollectionView
extension AdminViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    private func setupCollectionView() {
        sessionCollectionView.delegate = self
        sessionCollectionView.dataSource = self
        sessionCollectionView.register(AdminSessionCell.self, forCellWithReuseIdentifier: AdminSessionCell.identifier)
    }

    private func updateCollectionViewHeight(with list: [Session]) {
        let height = Constants.cellHeight*CGFloat(list.count)
        sessionCollectionView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
    }

    private func reloadCollectionView() {
        sessionCollectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sessionList = try? viewModel.output.sessionList.value() else { return .zero }
        return sessionList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdminSessionCell.identifier, for: indexPath) as? AdminSessionCell,
              let sessionList = try? viewModel.output.sessionList.value() else { return UICollectionViewCell() }
        let session = sessionList[indexPath.row]
        cell.updateUI(with: session)

        cell.arrowButton.rx.tap
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let session = sessionList[safe: indexPath.row],
                      session.type == .needAttendance else { return }
                self?.goToManagementVC(session: session)
            }).disposed(by: disposeBag)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.bounds.width, height: Constants.cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }

}

// MARK: - etc
private extension AdminViewController {

    func updateTodayView() {
        guard let todaySession = try? viewModel.output.todaySession.value() else { return }
        todayView.updateUI(session: todaySession)
    }

    func goToGradeVC() {
        let gradeVC = AdminGradeViewController(viewModel: viewModel)
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .gray_800
        navigationController?.pushViewController(gradeVC, animated: true)
    }

    func goToTodayManagementVC() {
        guard let todaySession = try? viewModel.output.todaySession.value() else { return }
        let managementVC = AdminManagementViewController(viewModel: viewModel, session: todaySession)
        navigationItem.backButtonTitle = ""
        navigationController?.isNavigationBarHidden = true
        navigationController?.pushViewController(managementVC, animated: true)
    }

    func goToManagementVC(session: Session) {
        let managementVC = AdminManagementViewController(viewModel: viewModel, session: session)
        navigationItem.backButtonTitle = ""
        navigationController?.isNavigationBarHidden = true
        navigationController?.pushViewController(managementVC, animated: true)
    }

    func goToLoginVC() {
        let loginVC = LoginViewController()
        let navC = UINavigationController(rootViewController: loginVC)
        navC.modalPresentationStyle = .fullScreen
        self.present(navC, animated: true)
    }

}

// MARK: - UI
private extension AdminViewController {

    func configureUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
    }

    func configureLayout() {
        view.addSubviews([scrollView])
        scrollView.addSubviews([contentView])
        contentView.addSubviews([cardView, dividerView, titleLabel, todayView, sessionTitleLabel, sessionCollectionView])

        scrollView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
            $0.width.equalToSuperview()
            $0.bottom.equalTo(sessionCollectionView.snp.bottom)
        }
        cardView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(90)
            $0.left.right.equalToSuperview().inset(Constants.horizontalPadding)
            $0.height.equalTo(Constants.topPadding)
        }
        dividerView.snp.makeConstraints {
            $0.top.equalTo(cardView.snp.bottom).offset(Constants.verticalPadding)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(Constants.dividerViewHeight)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(Constants.verticalPadding)
            $0.left.right.equalToSuperview().inset(Constants.horizontalPadding)
        }
        todayView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.verticalPadding)
            $0.left.right.equalToSuperview().inset(Constants.horizontalPadding)
            $0.height.equalTo(Constants.todayViewHeight)
        }
        sessionTitleLabel.snp.makeConstraints {
            $0.top.equalTo(todayView.snp.bottom).offset(Constants.verticalPadding)
            $0.left.right.equalToSuperview().inset(Constants.horizontalPadding)
        }
        sessionCollectionView.snp.makeConstraints {
            $0.top.equalTo(sessionTitleLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(Constants.horizontalPadding)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(Constants.cellHeight*20)
        }
    }

}
