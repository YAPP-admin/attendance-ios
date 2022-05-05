//
//  AdminGradeCell.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/04/13.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class AdminGradeCell: UICollectionViewCell {

    enum Constants {
        static let horizontalPadding: CGFloat = 24
        static let cellHeight: CGFloat = 60
    }

    private let collectionView: UICollectionView = {
        let layout = CollectionViewLeftAlignFlowLayout(cellSpacing: 0)
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    private let teamNameLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard(type: .semiBold, size: 18)
        label.textColor = .gray_1200
        label.text = "All-rounder 1팀"
        return label
    }()

    private let chevronButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "chevron_down"), for: .normal)
        return button
    }()

    private let topDividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray_300
        return view
    }()

    private let bottomDividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray_300
        return view
    }()

    private var disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        bindSubviews()

        setupCollectionView()

        configureUI()
        configureLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Bind
private extension AdminGradeCell {

    func bindSubviews() {
        chevronButton.rx.controlEvent([.touchUpInside])
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                print("chevronButton")
            }).disposed(by: disposeBag)
    }
}

// MARK: - CollectionView
extension AdminGradeCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AdminGradeMemberCell.self, forCellWithReuseIdentifier: AdminGradeMemberCell.identifier)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdminGradeMemberCell.identifier, for: indexPath) as? AdminGradeMemberCell else { return UICollectionViewCell() }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: bounds.width, height: Constants.cellHeight)
    }

}

// MARK: - UI
private extension AdminGradeCell {

    func configureUI() {
        backgroundColor = .white
    }

    func configureLayout() {
        addSubviews([teamNameLabel, chevronButton, collectionView, topDividerView, bottomDividerView])

        teamNameLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(Constants.horizontalPadding)
            $0.top.equalToSuperview().offset(20)
        }
        chevronButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(Constants.horizontalPadding)
            $0.centerY.equalTo(teamNameLabel)
        }
        collectionView.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.height.equalTo(Constants.cellHeight*2)
        }
        topDividerView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.top)
            $0.left.right.equalToSuperview().inset(Constants.horizontalPadding)
            $0.height.equalTo(1)
        }
        bottomDividerView.snp.makeConstraints {
            $0.bottom.equalTo(collectionView.snp.bottom)
            $0.left.right.equalToSuperview().inset(Constants.horizontalPadding)
            $0.height.equalTo(1)
        }
    }

}
