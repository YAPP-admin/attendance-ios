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

final class AdminGradeViewController: BaseAdminViewController {
    enum Constants {
        static let verticalPadding: CGFloat = 28
        static let horizontalPadding: CGFloat = 24
        static let topPadding: CGFloat = 88
        static let cellHeight: CGFloat = 60
        static let headerHeight: CGFloat = 48
    }

    private let groupCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: Constants.verticalPadding, left: 0, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    private let viewModel: AdminViewModel
    private var disposeBag = DisposeBag()

    override init(viewModel: AdminViewModel) {
        self.viewModel = viewModel
        super.init(viewModel: viewModel)
    }

    override init?(coder: NSCoder, viewModel: AdminViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder, viewModel: viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        super.bindSubViews()

        bindViewModel()
        
        setupCollectionView()

        configureUI()
        configureLayout()

        setRightSwipeRecognizer()
    }

    override func dismissWhenSwipeRight() {
        viewModel.input.selectedTeamIndexListInGrade.onNext([])
        navigationController?.popViewController(animated: true)
    }

}

// MARK: - Bind
extension AdminGradeViewController {
    func bindViewModel() {
        viewModel.input.selectedTeamIndexListInGrade
            .subscribe(onNext: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.reloadCollectionView()
                }
            }).disposed(by: disposeBag)

        viewModel.output.itemList
            .subscribe(onNext: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.reloadCollectionView()
                }
            }).disposed(by: disposeBag)

        viewModel.output.memberList
            .subscribe(onNext: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.reloadCollectionView()
                }
            }).disposed(by: disposeBag)
    }
}

// MARK: - CollectionView
extension AdminGradeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    private func setupCollectionView() {
        groupCollectionView.delegate = self
        groupCollectionView.dataSource = self
        groupCollectionView.register(AdminGradeCell.self, forCellWithReuseIdentifier: AdminGradeCell.identifier)
        groupCollectionView.register(AdminMessageHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: AdminMessageHeader.identifier)
    }

    private func reloadCollectionView() {
        groupCollectionView.reloadData()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let itemList = try? viewModel.output.itemList.value() else { return .zero }
        return itemList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdminGradeCell.identifier, for: indexPath) as? AdminGradeCell,
              let sessionList = try? viewModel.output.sessionList.value(),
              let memberList = try? viewModel.output.memberList.value(),
              var indexList = try? viewModel.input.selectedTeamIndexListInGrade.value() else { return .init() }
        let index = indexPath.row

        cell.chevronButton.rx.tap
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                indexList.toggleElement(index)
                self?.viewModel.input.selectedTeamIndexListInGrade.onNext(indexList)
            }).disposed(by: disposeBag)

        if let sessionId = sessionList.todaySession()?.sessionId {
            cell.sessionId = sessionId
        }
        cell.isShownMembers = indexList.contains(indexPath.row)
        cell.needAttendanceSessionIdList = sessionList.filter { $0.type == .needAttendance }.map { $0.sessionId }
        cell.updateSubViews()

        if let itemList = try? viewModel.output.itemList.value(), let item = itemList[safe: index] {
            cell.updateTeamNameLabel(name: item.displayName())

            let members = memberList.filter {
                (item as? Team) == $0.team ||
                (item as? Position) == $0.position
            }
            cell.setupMembers(members: members)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize(width: collectionView.bounds.width, height: Constants.cellHeight)

        guard let itemList = try? viewModel.output.itemList.value(),
              let memberList = try? viewModel.output.memberList.value(),
              let indexList = try? viewModel.input.selectedTeamIndexListInGrade.value(),
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
              let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: AdminMessageHeader.identifier, for: indexPath) as? AdminMessageHeader else { return .init() }
        header.configureLabel("점수가 실시간으로 반영되고 있어요")
        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.bounds.width
        let height = Constants.headerHeight
        return .init(width: width, height: height)
    }

}

// MARK: - UI
private extension AdminGradeViewController {

    func configureUI() {
        view.backgroundColor = .background
        navigationBarView.titleLabel.text = "누적 출결 점수"
    }

    func configureLayout() {
        view.addSubviews([groupCollectionView])

        groupCollectionView.snp.makeConstraints {
            $0.top.equalTo(segmentContainerView.snp.bottom).offset(24)
            $0.bottom.left.right.equalToSuperview()
        }
    }

}
