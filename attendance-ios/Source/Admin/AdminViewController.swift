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
        view.backgroundColor = .gray_200
        view.backgroundColor = .background_base
        return view
    }()

    private let cardView = AdminCardView()
    private let todayView = AdminTodayView()

    private let sessionCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .yapp_orange
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
    }

}

// MARK: - CollectionView
extension AdminViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    private func setupCollectionView() {
        sessionCollectionView.delegate = self

        sessionCollectionView.register(AdminSessionCell.self, forCellWithReuseIdentifier: AdminSessionCell.identifier)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdminSessionCell.identifier, for: indexPath) as? AdminSessionCell else { return UICollectionViewCell() }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 500, height: Constants.cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }

}

// MARK: - etc
private extension AdminViewController {

    func goToGradeVC() {
        let gradeVC = AdminGradeViewController(viewModel: viewModel)
        navigationItem.backButtonTitle = ""
        navigationItem.title = "누적 출결 점수"
        navigationController?.navigationBar.tintColor = .gray_800
        navigationController?.pushViewController(gradeVC, animated: true)
    }

    func goToManagementVC() {
        let managementVC = AdminManagementViewController(viewModel: viewModel)
        navigationItem.backButtonTitle = ""
        navigationItem.title = "YAPP 오리엔테이션"
        navigationController?.navigationBar.tintColor = .gray_800
        navigationController?.pushViewController(managementVC, animated: true)
    }

    func setupDelegate() {

    }

    func configureUI() {
        view.backgroundColor = .white
    }

    func configureLayout() {
        view.addSubviews([cardView, dividerView, titleLabel, todayView, sessionCollectionView])

        cardView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(105)
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
        sessionCollectionView.snp.makeConstraints {
            $0.top.equalTo(todayView.snp.bottom).offset(Constants.verticalPadding)
            $0.left.right.equalToSuperview().inset(Constants.horizontalPadding)
            $0.bottom.equalToSuperview().inset(48)
        }
    }

}
