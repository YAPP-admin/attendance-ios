//
//  HomeAttendanceCheckViewController.swift
//  attendance-ios
//
//  Created by 김보민 on 2022/04/19.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import SnapKit

final class HomeAttendanceCheckViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray_1200
        label.font = .Pretendard(type: .regular, size: 18)
        label.text = "출결 점수 확인"
        label.textAlignment = .center
        return label
    }()
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(HomeMyScoreCollectionViewCell.self, forCellWithReuseIdentifier: "HomeMyScoreCollectionViewCell")
        collectionView.isPagingEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true

        addSubViews()
        bindView()
    }

    func addSubViews() {
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(11)
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }

    func bindView() {
        collectionView.dataSource = self
    }
}

extension HomeAttendanceCheckViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeMyScoreCollectionViewCell", for: indexPath) as? HomeMyScoreCollectionViewCell {
           cell.backgroundColor = .yellow.withAlphaComponent(0.1)
           return cell
       }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: UIScreen.main.bounds.width, height: 391)
        let width = view.frame.width
        return CGSize(width: width, height: 100)
    }
}
