//
//  AdminViewController.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/03/16.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class AdminViewController: UIViewController {

    enum Constants {
        static let padding: CGFloat = 24
    }

    private let cardView = AdminCardView()

    private let viewModel = AdminViewModel()
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupDelegate()
        configureUI()
        configureLayout()
    }

}

private extension AdminViewController {

    func bindViewModel() {
//        cardButton.rx.tap
//            .bind { [weak self] _ in
//                print("누적 점수 확인하기")
//            }
//            .disposed(by: disposeBag)
    }

    func setupDelegate() {

    }

    func configureUI() {
        view.backgroundColor = .white
    }

    func configureLayout() {
        view.addSubview(cardView)

        cardView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(105)
            $0.left.right.equalToSuperview().inset(Constants.padding)
            $0.height.equalTo(100)
        }
    }

}
