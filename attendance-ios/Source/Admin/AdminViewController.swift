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
        collectionView.backgroundColor = .gray_200
        return collectionView
    }()

    private let viewModel = AdminViewModel()
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindSubviews()
        bindViewModel()

        setupDelegate()
        configureUI()
        configureLayout()
    }

}

private extension AdminViewController {

    func bindSubviews() {
        let tapGesture = UITapGestureRecognizer()
        cardView.addGestureRecognizer(tapGesture)

        tapGesture.rx.event
            .bind(onNext: { [weak self] _ in
                self?.viewModel.input.tapCardView.accept(())
            }).disposed(by: disposeBag)
    }

    func bindViewModel() {
        viewModel.output.goToGradeVC
            .observe(on: MainScheduler.instance)
            .bind(onNext: goToGradeVC)
            .disposed(by: disposeBag)
    }

    func goToGradeVC() {
        print("goToGradeVC")
        let gradeVC = AdminGradeViewController(viewModel: viewModel)
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .gray_800
        navigationController?.pushViewController(gradeVC, animated: true)
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
