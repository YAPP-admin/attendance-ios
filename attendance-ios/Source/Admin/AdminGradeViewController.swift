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

final class AdminGradeViewController: UIViewController {

    enum Constants {
        static let padding: CGFloat = 24
    }

    private let viewModel: AdminViewModel
    private var disposeBag = DisposeBag()

    init(viewModel: AdminViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    init?(coder: NSCoder, viewModel: AdminViewModel) {
        self.viewModel = viewModel
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
        setupNavigationTitle()

        configureUI()
        configureLayout()
    }

}

// MARK: - Bind
extension AdminGradeViewController {

    func bindSubviews() {

    }

    func bindViewModel() {

    }

}

// MARK: - etc
private extension AdminGradeViewController {

    func setupDelegate() {

    }

    func setupNavigationTitle() {
        navigationItem.title = "누적 출결 점수"

    }

}

// MARK: - UI
private extension AdminGradeViewController {

    func configureUI() {
        view.backgroundColor = .white
    }

    func configureLayout() {

    }

}
