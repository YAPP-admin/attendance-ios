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
        label.font = .Pretendard(type: .medium, size: 18)
        label.textColor = .gray_1200
        label.numberOfLines = 1
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
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

    private var session: Session

    private let viewModel: AdminViewModel
    private var disposeBag = DisposeBag()

    init(viewModel: AdminViewModel, session: Session) {
        self.viewModel = viewModel
        self.session = session
        super.init(nibName: nil, bundle: nil)
    }

    init?(coder: NSCoder, viewModel: AdminViewModel, session: Session) {
        self.viewModel = viewModel
        self.session = session
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
        viewModel.output.showBottomsheet
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.showBottomSheet()
            }).disposed(by: disposeBag)
    }

}

// MARK: -
extension AdminManagementViewController: AdminBottomSheetViewDelegate {

    // TODO: - 출결 업데이트
    func didSelect(at type: AttendanceType) {
        guard let member = try? viewModel.input.selectedMemberInManagement.value() else { return }
        let sessionId = session.sessionId
        var attendances = member.attendances
        attendances[sessionId].type = AttendanceData(point: type.point, text: type.text)
        viewModel.updateAttendances(memberId: member.id, attendances: attendances)
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
        guard let teamList = try? viewModel.output.teamList.value() else { return .zero }
        return teamList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdminManagementCell.identifier, for: indexPath) as? AdminManagementCell,
              let memberList = try? viewModel.output.memberList.value() else { return UICollectionViewCell() }
        cell.setupViewModel(viewModel)
        let index = indexPath.row

        cell.chevronButton.rx.controlEvent([.touchUpInside])
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                print("index: \(indexPath.row)")
            }).disposed(by: disposeBag)

        if let teamList = try? viewModel.output.teamList.value(), let team = teamList[safe: index] {
            let teamNames = teamList.map { $0.name() }
            let teamName = teamNames[indexPath.row]
            cell.updateTeamNameLabel(name: teamName)

            let members = memberList.filter { $0.team == team  }
            cell.setupSessionId(sessionId: session.sessionId)
            cell.setupTeam(team: team)
            cell.setupMembers(members: members)
        }

        return cell
    }

    // TODO: - Show/Hide
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height = CGFloat.zero
        height = Constants.cellHeight*6

        return CGSize(width: collectionView.bounds.width, height: height)
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
        bottomSheetView.delegate = self
    }

    func setupNavigationTitle() {
        navigationTitleLabel.text = session.title
    }

    func setupMessage() {
        guard let memberList = try? viewModel.output.memberList.value() else { return }
        let attendances = memberList.flatMap { $0.attendances }.filter { $0.sessionId == session.sessionId }.filter { $0.type.text != AttendanceType.absence.text }
        adminMesasgeView.configureLabel("\(attendances.count)명이 출석했어요")
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
