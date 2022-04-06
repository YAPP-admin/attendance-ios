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
        static let padding: CGFloat = 24
        static let topPadding: CGFloat = 100
    }

    private let adminMesasgeView = AdminMessageView()

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
extension AdminManagementViewController {

    func bindSubviews() {

    }

    func bindViewModel() {

    }

}

// MARK: - etc
private extension AdminManagementViewController {

    func setupDelegate() {

    }

    func setupNavigationTitle() {
        navigationItem.title = "YAPP 오리엔테이션"
    }

}

// MARK: - UI
private extension AdminManagementViewController {

    func configureUI() {
        view.backgroundColor = .white
        adminMesasgeView.configureLabel("10명이 출석했어요")
    }

    func configureLayout() {
        view.addSubviews([adminMesasgeView])

        adminMesasgeView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.topPadding)
            $0.left.right.equalToSuperview().inset(Constants.padding)
            $0.height.equalTo(48)
        }
    }

}
