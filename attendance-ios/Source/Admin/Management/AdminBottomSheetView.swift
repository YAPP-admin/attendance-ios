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

protocol AdminBottomSheetViewDelegate: AnyObject {
    func didSelect(at type: AttendanceType)
}

final class AdminBottomSheetView: UIView {

    enum Constants {
        static let topPadding: CGFloat = 24
        static let cornerRadius: CGFloat = 20
        static let bottomSheetHeight: CGFloat = 300
        static let bottomSheetCornerRadius: CGFloat = 20
        static let bottomSheetCellHeight: CGFloat = 52
    }

    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        return view
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    weak var delegate: AdminBottomSheetViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
        addTapGesture()

        configureUI()
        configureBottomSheetUI()
        configureLayout()
    }

    private var disposeBag = DisposeBag()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Animation
private extension AdminBottomSheetView {

    // TODO: - 애니메이션
    func showBottomSheet() {
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.containerView.snp.updateConstraints {
                $0.bottom.equalToSuperview().inset(0)
            }
            self?.containerView.layoutIfNeeded()
        })
    }

    func hideBottomSheet() {
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.containerView.snp.updateConstraints {
                $0.bottom.equalToSuperview().inset(-Constants.bottomSheetHeight)
            }
            self?.containerView.layoutIfNeeded()
        }, completion: { [weak self] _ in
            self?.removeFromSuperview()
        })
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
        let attendanceType = AttendanceType.allCases[indexPath.row]
        cell.didSelect()
        delegate?.didSelect(at: attendanceType)
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
        backgroundView.addGestureRecognizer(tapGesture)

        tapGesture.rx.event
            .bind(onNext: { [weak self] _ in
                self?.removeFromSuperview()
            }).disposed(by: disposeBag)
    }

    func configureUI() {
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
    }

    func configureBottomSheetUI() {
        containerView.layer.cornerRadius = Constants.bottomSheetCornerRadius
    }

    func configureLayout() {
        addSubviews([backgroundView, containerView])
        containerView.addSubview(collectionView)

        backgroundView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
        containerView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(-Constants.bottomSheetHeight)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(Constants.bottomSheetHeight)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.topPadding)
            $0.left.right.bottom.equalToSuperview()
        }

        showBottomSheet()
    }

}
