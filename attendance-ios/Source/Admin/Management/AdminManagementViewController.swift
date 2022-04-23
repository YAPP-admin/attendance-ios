//
//  AdminManagementViewController.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/03/16.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class AdminManagementViewController: UIViewController {

    enum Constants {
        static let horizontalPadding: CGFloat = 24
        static let verticalPadding: CGFloat = 28
        static let topPadding: CGFloat = 116
        static let cellHeight: CGFloat = 60
    }

    // MARK: Navigation
    private let navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard(type: .regular, size: 18)
        label.textColor = .gray_1200
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()

    private let navigationBackButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "back"), for: .normal)
        return button
    }()

    private let adminMesasgeView = AdminMessageView()

    private let teamCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    private let bottomSheetView = AdminBottomSheetView()

    private let viewModel: AdminViewModel
    private var disposeBag = DisposeBag()

    init(viewModel: AdminViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    init?(coder: NSCoder, viewModel: AdminViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindSubviews()
        bindViewModel()

        setupDelegate()
        setupCollectionView()
        setupNavigationTitle()
        setupMessage()

        configureUI()
        configureLayout()
        configureNavigationLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
    }

}

// MARK: - Bind
extension AdminManagementViewController {

    func bindSubviews() {
        navigationBackButton.rx.controlEvent([.touchUpInside])
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }

    func bindViewModel() {

    }

}

// MARK: - CollectionView
extension AdminManagementViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    private func setupCollectionView() {
        teamCollectionView.delegate = self
        teamCollectionView.dataSource = self
        teamCollectionView.register(AdminManagementCell.self, forCellWithReuseIdentifier: AdminManagementCell.identifier)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }

    // TODO: - 셀 인덱스
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdminManagementCell.identifier, for: indexPath) as? AdminManagementCell else { return UICollectionViewCell() }

//        cell.attendanceButton.addTarget(self, action: #selector(cellTapped), for: .touchUpInside)

        cell.attendanceButton.rx.controlEvent([.touchUpInside])
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                print("index: \(indexPath.row)")
                self?.viewModel.input.selectedIndexInManagement.onNext(indexPath.row)
                self?.showBottomSheet()
            }).disposed(by: disposeBag)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: Constants.cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }

}

// MARK: - BottomSheet
private extension AdminManagementViewController {

    func showBottomSheet() {
        view.addSubviews([bottomSheetView])

        bottomSheetView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
    }

}

// MARK: - etc
private extension AdminManagementViewController {

    func setupDelegate() {

    }

    func setupNavigationTitle() {
        navigationTitleLabel.text = "YAPP 오리엔테이션"
    }

    func setupMessage() {
        adminMesasgeView.configureLabel("10명이 출석했어요")
    }

}

// MARK: - UI
private extension AdminManagementViewController {

    func configureUI() {
        view.backgroundColor = .white
    }

    func configureLayout() {
        view.addSubviews([adminMesasgeView, teamCollectionView])

        adminMesasgeView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.topPadding)
            $0.left.right.equalToSuperview().inset(Constants.horizontalPadding)
            $0.height.equalTo(48)
        }
        teamCollectionView.snp.makeConstraints {
            $0.top.equalTo(adminMesasgeView.snp.bottom).offset(Constants.verticalPadding)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    func configureNavigationLayout() {
        view.addSubviews([navigationTitleLabel, navigationBackButton])

        navigationTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(56)
            $0.centerX.equalToSuperview()
            $0.left.right.equalToSuperview().inset(60)
        }
        navigationBackButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(56)
            $0.left.equalToSuperview().offset(Constants.horizontalPadding)
            $0.width.height.equalTo(24)
        }
    }

}
