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
        static let verticalPadding: CGFloat = 28
        static let horizontalPadding: CGFloat = 24
        static let topPadding: CGFloat = 88
        static let cellHeight: CGFloat = 60
        static let headerHeight: CGFloat = 104
    }

    private let navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard(type: .regular, size: 18)
        label.textColor = .gray_1200
        label.numberOfLines = 1
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()

    private let teamCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    private let bottomSheetView: AdminBottomSheetView = {
        let view = AdminBottomSheetView()
        view.isHidden = true
        return view
    }()

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
        bindViewModel()

        setupDelegate()
        setupCollectionView()
        setupNavigationTitle()

        configureUI()
        configureLayout()

        addNavigationBackButton()
        setRightSwipeRecognizer()
    }

    override func navigationBackButtonTapped() {
        viewModel.input.selectedTeamIndexListInManagement.onNext([])
        navigationController?.popViewController(animated: true)
    }

    override func dismissWhenSwipeRight() {
        viewModel.input.selectedTeamIndexListInManagement.onNext([])
        navigationController?.popViewController(animated: true)
    }

}

// MARK: - Bind
extension AdminManagementViewController {

    func bindViewModel() {
        viewModel.input.selectedTeamIndexListInManagement
            .subscribe(onNext: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.reloadCollectionView()
                }
            }).disposed(by: disposeBag)

        viewModel.output.memberList
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.reloadCollectionView()
            }).disposed(by: disposeBag)

        viewModel.output.showBottomsheet
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.showBottomSheet()
            }).disposed(by: disposeBag)
    }

}

// MARK: - Update Attendance
extension AdminManagementViewController: AdminBottomSheetViewDelegate {

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
        teamCollectionView.register(AdminMessageHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: AdminMessageHeader.identifier)
    }

    private func reloadCollectionView() {
        teamCollectionView.reloadData()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let teamList = try? viewModel.output.teamList.value() else { return .zero }
        return teamList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdminManagementCell.identifier, for: indexPath) as? AdminManagementCell,
              let memberList = try? viewModel.output.memberList.value(),
              var indexList = try? viewModel.input.selectedTeamIndexListInManagement.value() else { return .init() }
        let index = indexPath.row

        cell.chevronButton.rx.tap
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                indexList.toggleElement(index)
                self?.viewModel.input.selectedTeamIndexListInManagement.onNext(indexList)
            }).disposed(by: disposeBag)

        cell.isShownMembers = indexList.contains(indexPath.row)
        cell.updateSubViews()

        if let teamList = try? viewModel.output.teamList.value(), let team = teamList[safe: index] {
            let teamNames = teamList.map { $0.name() }
            let teamName = teamNames[indexPath.row]
            cell.updateTeamNameLabel(name: teamName)

            let members = memberList.filter { $0.team == team  }
            cell.setupSessionId(sessionId: session.sessionId)
            cell.setupTeam(team: team)
            cell.setupMembers(members: members)
        }
        cell.setupViewModel(viewModel)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize(width: collectionView.bounds.width, height: Constants.cellHeight)

        guard let teamList = try? viewModel.output.teamList.value(),
              let memberList = try? viewModel.output.memberList.value(),
              let indexList = try? viewModel.input.selectedTeamIndexListInManagement.value(),
              indexList.contains(indexPath.row) == true else { return size }

        if let team = teamList[safe: indexPath.row] {
            let members = memberList.filter { $0.team == team }
            size.height = Constants.cellHeight*CGFloat(members.count+1)
        }

        return size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    // MARK: - Header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: AdminMessageHeader.identifier, for: indexPath) as? AdminMessageHeader,
              let memberList = try? viewModel.output.memberList.value() else { return .init() }

        let attendances = memberList.flatMap { $0.attendances }.filter { $0.sessionId == session.sessionId }.filter { $0.type.text != AttendanceType.absence.text }
        header.configureLabel("\(attendances.count)명이 출석했어요")
        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.bounds.width
        let height = Constants.headerHeight
        return .init(width: width, height: height)
    }

}

// MARK: - BottomSheet
private extension AdminManagementViewController {

    func showBottomSheet() {
        bottomSheetView.isHidden = false
        bottomSheetView.showBottomSheet()
    }

}

// MARK: - Setup
private extension AdminManagementViewController {

    func setupDelegate() {
        bottomSheetView.delegate = self
    }

    func setupNavigationTitle() {
        navigationTitleLabel.text = session.title
    }

}

// MARK: - UI
private extension AdminManagementViewController {

    func configureUI() {
        view.backgroundColor = .white
    }

    func configureLayout() {
        view.addSubviews([teamCollectionView, bottomSheetView])

        teamCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.topPadding)
            $0.bottom.left.right.equalToSuperview()
        }
        bottomSheetView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
    }

}
