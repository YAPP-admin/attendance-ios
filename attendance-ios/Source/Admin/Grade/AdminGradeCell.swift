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

    let chevronButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "chevron_down"), for: .normal)
        return button
    }()

    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray_300
        return view
    }()

    var isShownMembers: Bool = true

    private var disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()

        configureUI()
        updateSubViews()
        configureLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

}

// MARK: - Show/Hide
extension AdminGradeCell {

    func showMembers() {
        isShownMembers = true
        updateSubViewsWhenShow()
    }

    func hideMembers() {
        isShownMembers = false
        updateSubViewsWhenHide()
    }

    func updateSubViews() {
        isShownMembers == true ? updateSubViewsWhenShow() : updateSubViewsWhenHide()
    }

    private func updateSubViewsWhenShow() {
        showCollectionView()
        showChevronButton()
        showDividerView()
    }

    private func updateSubViewsWhenHide() {
        hideCollectionView()
        hideChevronButton()
        hideDividerView()
    }

    private func showCollectionView() {
        let height = Constants.cellHeight*2
        collectionView.snp.remakeConstraints {
            $0.height.equalTo(height)
        }
        reloadCollectionView()
    }

    private func hideCollectionView() {
        let height = 0
        collectionView.snp.remakeConstraints {
            $0.height.equalTo(height)
        }
        reloadCollectionView()
    }

    private func showChevronButton() {
        let image = UIImage(named: "chevron_up")
        chevronButton.setImage(image, for: .normal)
    }

    private func hideChevronButton() {
        let image = UIImage(named: "chevron_down")
        chevronButton.setImage(image, for: .normal)
    }

    private func showDividerView() {
        dividerView.isHidden = false
    }

    private func hideDividerView() {
        dividerView.isHidden = true
    }

}

// MARK: - CollectionView
extension AdminGradeCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AdminGradeMemberCell.self, forCellWithReuseIdentifier: AdminGradeMemberCell.identifier)
    }

    private func reloadCollectionView() {
        collectionView.reloadData()
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
        addSubviews([teamNameLabel, chevronButton, collectionView, dividerView])

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
        dividerView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(Constants.horizontalPadding)
            $0.height.equalTo(1)
        }
    }

}
