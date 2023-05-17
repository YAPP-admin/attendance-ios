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

final class AdminManagementViewController: BaseAdminViewController {
    enum Constants {
        static let verticalPadding: CGFloat = 28
        static let horizontalPadding: CGFloat = 24
        static let topPadding: CGFloat = 88
        static let cellHeight: CGFloat = 64
        static let headerHeight: CGFloat = 88
    }
    
    private let groupCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: Constants.verticalPadding, left: 0, bottom: 0, right: 0)
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
        super.init(viewModel: viewModel)
    }
    
    init?(coder: NSCoder, viewModel: AdminViewModel, session: Session) {
        self.viewModel = viewModel
        self.session = session
        super.init(coder: coder, viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.bindSubViews()
        
        bindViewModel()
        setupDelegate()
        setupCollectionView()
        configureUI()
        configureLayout()
        
        setRightSwipeRecognizer()
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
                self?.reloadCollectionView()
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
        
        viewModel.output.itemList
            .subscribe(onNext: { [weak self] _ in
                self?.reloadCollectionView()
            }).disposed(by: disposeBag)
    }
    
}

// MARK: - Update Attendance
extension AdminManagementViewController: AdminBottomSheetViewDelegate {
    
    func didSelect(at status: Status) {
        guard let member = try? viewModel.input.selectedMemberInManagement.value() else { return }
        let sessionId = session.sessionId
        var attendances = member.attendances
        attendances[sessionId].status = status
        viewModel.updateAttendances(memberId: member.id, attendances: attendances)
    }
    
}

// MARK: - CollectionView
extension AdminManagementViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    private func setupCollectionView() {
        groupCollectionView.delegate = self
        groupCollectionView.dataSource = self
        groupCollectionView.register(AdminManagementCell.self, forCellWithReuseIdentifier: AdminManagementCell.identifier)
        groupCollectionView.register(AttendanceSummaryHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: AttendanceSummaryHeaderView.identifier)
    }
    
    private func reloadCollectionView() {
        DispatchQueue.main.async {
            self.groupCollectionView.reloadData()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let itemList = try? viewModel.output.itemList.value() else { return .zero }
        return itemList.count
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
        
        if let itemList = try? viewModel.output.itemList.value(), let item = itemList[safe: index] {
            cell.updateTeamNameLabel(name: item.displayName())
            
            let members = memberList.filter {
                (item as? Team) == $0.team ||
                (item as? Position) == $0.position
            }
            cell.setupSessionId(sessionId: session.sessionId)
            cell.setupMembers(members: members)
        }
        cell.setupViewModel(viewModel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize(width: collectionView.bounds.width, height: Constants.cellHeight)
        
        guard let itemList = try? viewModel.output.itemList.value(),
              let memberList = try? viewModel.output.memberList.value(),
              let indexList = try? viewModel.input.selectedTeamIndexListInManagement.value(),
              indexList.contains(indexPath.row) == true else { return size }
        
        if let item = itemList[safe: indexPath.row] {
            let members = memberList.filter {
                (item as? Team) == $0.team ||
                (item as? Position) == $0.position
            }
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
              let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: AttendanceSummaryHeaderView.identifier, for: indexPath) as? AttendanceSummaryHeaderView,
              let memberList = try? viewModel.output.memberList.value() else { return .init() }
        header.configureData(memberList, sessionID: session.sessionId)
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
}

// MARK: - UI
private extension AdminManagementViewController {
    
    func configureUI() {
        view.backgroundColor = .background
        navigationBarView.titleLabel.text = session.title
    }
    
    func configureLayout() {
        view.addSubviews([groupCollectionView, bottomSheetView])
        
        groupCollectionView.snp.makeConstraints {
            $0.top.equalTo(segmentContainerView.snp.bottom).offset(24)
            $0.bottom.left.right.equalToSuperview()
        }
        bottomSheetView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
    }
}
