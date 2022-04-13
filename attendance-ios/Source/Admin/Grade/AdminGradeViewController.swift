//
//  AdminGradeViewController.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/03/16.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class AdminGradeViewController: UIViewController {

    enum Constants {
        static let horizontalPadding: CGFloat = 24
        static let verticalPadding: CGFloat = 28
        static let topPadding: CGFloat = 116
        static let cellHeight: CGFloat = 60
    }

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
extension AdminGradeViewController {

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

// MARK: - etc
private extension AdminGradeViewController {

    func setupDelegate() {

    }

    func setupNavigationTitle() {
        navigationTitleLabel.text = "누적 출결 점수"
    }

    func setupMessage() {
        adminMesasgeView.configureLabel("10명이 출석했어요")
    }

}

// MARK: - CollectionView
extension AdminGradeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    private func setupCollectionView() {
        teamCollectionView.delegate = self
        teamCollectionView.dataSource = self
        teamCollectionView.register(AdminGradeCell.self, forCellWithReuseIdentifier: AdminGradeCell.identifier)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdminGradeCell.identifier, for: indexPath) as? AdminGradeCell else { return UICollectionViewCell() }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.bounds.width-Constants.horizontalPadding*2, height: Constants.cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }

}

// MARK: - UI
private extension AdminGradeViewController {

    func configureUI() {
        view.backgroundColor = .white
        adminMesasgeView.configureLabel("점수가 실시간으로 반영되고 있어요")
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
