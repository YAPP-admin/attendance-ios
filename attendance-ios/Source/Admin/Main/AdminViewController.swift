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
        static let horizontalPadding: CGFloat = 24
        static let verticalPadding: CGFloat = 28
        static let dividerViewHeight: CGFloat = 12
        static let todayViewHeight: CGFloat = 65
        static let cellHeight: CGFloat = 60
    }

    private let settingButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "setting"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return button
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
        bindSubviews()
        bindViewModel()

        setupDelegate()
        setupCollectionView()

        configureUI()
        configureLayout()
    }

}

// MARK: - Bind
private extension AdminViewController {

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
                self?.viewModel.input.tapManagementButton.accept(())
            }).disposed(by: disposeBag)

        settingButton.rx.controlEvent([.touchUpInside])
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.input.tapSettingButton.accept(())
            }).disposed(by: disposeBag)
    }

    func bindViewModel() {
        viewModel.output.goToGradeVC
            .observe(on: MainScheduler.instance)
            .bind(onNext: goToGradeVC)
            .disposed(by: disposeBag)

        viewModel.output.goToManagementVC
            .observe(on: MainScheduler.instance)
            .bind(onNext: goToManagementVC)
            .disposed(by: disposeBag)

        viewModel.output.goToSettingVC
            .observe(on: MainScheduler.instance)
            .bind(onNext: goToSettingVC)
            .disposed(by: disposeBag)
    }

}

// MARK: - CollectionView
extension AdminViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    private func setupCollectionView() {
        sessionCollectionView.delegate = self
        sessionCollectionView.dataSource = self
        sessionCollectionView.register(AdminSessionCell.self, forCellWithReuseIdentifier: AdminSessionCell.identifier)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdminSessionCell.identifier, for: indexPath) as? AdminSessionCell else { return UICollectionViewCell() }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.bounds.width, height: Constants.cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        goToManagementVC()
    }

}

// MARK: - etc
private extension AdminViewController {

    func goToGradeVC() {
        let gradeVC = AdminGradeViewController(viewModel: viewModel)
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .gray_800
        navigationController?.pushViewController(gradeVC, animated: true)
    }

    func goToManagementVC() {
        let managementVC = AdminManagementViewController(viewModel: viewModel)
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .gray_800
        navigationController?.pushViewController(managementVC, animated: true)
    }

    func goToSettingVC() {
        print("goToSettingVC")
    }

    func setupDelegate() {

    }

}

// MARK: - UI
private extension AdminViewController {

    func configureUI() {
        view.backgroundColor = .white
    }

    func configureLayout() {
        view.addSubviews([settingButton, cardView, dividerView, titleLabel, todayView, sessionTitleLabel, sessionCollectionView])

        settingButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Constants.verticalPadding)
            $0.right.equalToSuperview().inset(Constants.horizontalPadding)
            $0.width.height.equalTo(44)
        }
        cardView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(80)
            $0.left.right.equalToSuperview().inset(Constants.horizontalPadding)
            $0.height.equalTo(100)
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
        }
    }

}
