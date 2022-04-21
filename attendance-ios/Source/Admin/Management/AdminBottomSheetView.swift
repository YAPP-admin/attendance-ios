//
//  AdminBottomSheetView.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/04/01.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class AdminBottomSheetView: UIView {

    enum Constants {
        static let padding: CGFloat = 24
        static let cornerRadius: CGFloat = 20
        static let topPadding: CGFloat = 116
        static let bottomSheetHeight: CGFloat = 300
        static let bottomSheetCornerRadius: CGFloat = 20
        static let bottomSheetCellHeight: CGFloat = 52
    }

    private let bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.setTopCornerRadius(radius: Constants.cornerRadius)
        return view
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
        addTapGesture()
        addTapGestureToBottomSheetBackground()

        configureUI()
        configureBottomSheetUI()
        configureLayout()
    }

    private var disposeBag = DisposeBag()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private extension AdminBottomSheetView {

    func addTapGestureToBottomSheetBackground() {
        let tapGesture = UITapGestureRecognizer()
            backgroundView.addGestureRecognizer(tapGesture)

        tapGesture.rx.event
            .bind(onNext: { [weak self] _ in
                self?.hideBottomSheet()
            }).disposed(by: disposeBag)
    }

    // TODO: - 애니메이션
    func showBottomSheet() {

    }

    func hideBottomSheet() {
//        bottomSheetView.snp.updateConstraints {
//            $0.height.equalTo(273)
//        }
    }

}

// MARK: - CollectionView
extension AdminBottomSheetView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AdminBottomSheetCell.self, forCellWithReuseIdentifier: AdminBottomSheetCell.identifier)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        AttendanceType.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdminBottomSheetCell.identifier, for: indexPath) as? AdminBottomSheetCell else { return UICollectionViewCell() }
        let attendance = AttendanceType.allCases[indexPath.row].text
        cell.updateLabel(attendance)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: Constants.bottomSheetCellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? AdminBottomSheetCell else { return }
        cell.didSelect()
        let attendanceType = AttendanceType.allCases[indexPath.row]
        print("attendanceType: \(attendanceType)")
        hideBottomSheet()
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? AdminBottomSheetCell else { return }
        cell.didDeselect()
    }

}

// MARK: - UI
private extension AdminBottomSheetView {

    func addTapGesture() {
        let tapGesture = UITapGestureRecognizer()
        addGestureRecognizer(tapGesture)

        tapGesture.rx.event
            .bind(onNext: { [weak self] _ in
                self?.removeFromSuperview()
            }).disposed(by: disposeBag)
    }

    func configureUI() {
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
    }

    func configureBottomSheetUI() {
        bottomSheetView.layer.cornerRadius = Constants.bottomSheetCornerRadius
    }

    func configureLayout() {
        addSubview(bottomSheetView)
        bottomSheetView.addSubview(collectionView)

        bottomSheetView.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.height.equalTo(Constants.bottomSheetHeight)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.cornerRadius/2)
            $0.left.right.bottom.equalToSuperview()
        }
    }

}
