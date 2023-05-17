//
//  AdminManagementCell.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/04/23.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class AdminManagementCell: UICollectionViewCell {

    enum Constants {
        static let horizontalPadding: CGFloat = 24
        static let cornerRadius: CGFloat = 8
        static let buttonSize: CGSize = .init(width: 77, height: 33)
        static let cellHeight: CGFloat = 64
    }

    private let collectionView: UICollectionView = {
        let layout = CollectionViewLeftAlignFlowLayout(cellSpacing: 0)
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    private let headerView = UIView()

    private let teamNameLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard(type: .semiBold, size: 18)
        label.textColor = .gray_1200
        return label
    }()

    private let attendanceRateLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard(type: .medium, size: 14)
        label.textColor = .yapp_orange
        return label
    }()
    
    let chevronButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "chevron_down"), for: .normal)
        return button
    }()

    private let topDividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray_300
        view.isHidden = true
        return view
    }()

    private let bottomDividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray_300
        view.isHidden = true
        return view
    }()

    var sessionId: Int = 0
    var members: [Member] = []
    var isShownMembers: Bool = true

    private var viewModel: AdminViewModel?
    private var disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()

        configureUI()
        configureLayout()
        updateSubViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

}

// MARK: - Setup
extension AdminManagementCell {

    func setupViewModel(_ viewModel: AdminViewModel) {
        self.viewModel = viewModel
    }

    func setupSessionId(sessionId: Int) {
        self.sessionId = sessionId
    }

    func setupMembers(members: [Member]) {
        let numOfAttendees = members
            .flatMap { $0.attendances }
            .filter { $0.sessionId == sessionId }
            .filter { $0.status != .absent }
            .count
        
        attendanceRateLabel.text = "\(numOfAttendees)/\(members.count)"
        self.members = members
        reloadCollectionView()
    }

    func updateTeamNameLabel(name: String) {
        teamNameLabel.text = name
    }

}

// MARK: - Show/Hide
extension AdminManagementCell {

    func updateSubViews() {
        isShownMembers == true ? updateSubViewsWhenShow() : updateSubViewsWhenHide()
    }

    func updateSubViewsWhenShow() {
        updateButtonWhenShow()
        showDividerView()
    }

    func updateSubViewsWhenHide() {
        updateButtonWhenHide()
        hideDividerView()
    }

    private func updateButtonWhenShow() {
        let image = UIImage(named: "chevron_up")
        chevronButton.setImage(image, for: .normal)
    }

    private func updateButtonWhenHide() {
        let image = UIImage(named: "chevron_down")
        chevronButton.setImage(image, for: .normal)
    }

    private func showDividerView() {
        topDividerView.isHidden = false
        bottomDividerView.isHidden = false
    }

    private func hideDividerView() {
        topDividerView.isHidden = true
        bottomDividerView.isHidden = true
    }

}

// MARK: - CollectionView
extension AdminManagementCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AdminManagementMemberCell.self, forCellWithReuseIdentifier: AdminManagementMemberCell.identifier)
    }

    private func reloadCollectionView() {
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return members.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdminManagementMemberCell.identifier, for: indexPath) as? AdminManagementMemberCell else { return UICollectionViewCell() }
        let member = members[indexPath.row]
        cell.updateSubViews(with: member)

        cell.attendanceButton.rx.controlEvent([.touchUpInside])
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let member = self.members[indexPath.row]
                self.viewModel?.input.selectedMemberInManagement.onNext(member)
            }).disposed(by: disposeBag)

        let attendance = member.attendances[sessionId]
        cell.updateAttendance(with: attendance)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: bounds.width, height: Constants.cellHeight)
    }

}

// MARK: - UI
private extension AdminManagementCell {

    func configureUI() {
        backgroundColor = .background
    }

    func configureLayout() {
        addSubviews([headerView, collectionView, topDividerView, bottomDividerView])
        headerView.addSubviews([teamNameLabel, attendanceRateLabel, chevronButton])

        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constants.cellHeight)
        }
        teamNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(Constants.horizontalPadding)
            $0.centerY.equalToSuperview()
        }
        attendanceRateLabel.snp.makeConstraints {
            $0.leading.equalTo(teamNameLabel.snp.trailing).offset(6)
            $0.centerY.equalToSuperview()
        }
        chevronButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Constants.horizontalPadding)
            $0.centerY.equalToSuperview()
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.bottom.left.right.equalToSuperview()
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
