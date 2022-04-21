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
        static let topPadding: CGFloat = 116
    }

    // MARK: Navigation
    private let navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard(type: .regular, size: 18)
        label.textColor = .gray_1200
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()

    private let navigationBackButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "back"), for: .normal)
        return button
    }()

    private let adminMesasgeView = AdminMessageView()

    // MARK: - BottomSheet
    private let bottomSheetTestButton: UIButton = {
        let button = UIButton()
        button.setTitle("바텀 시트 테스트", for: .normal)
        button.backgroundColor = .yapp_orange
        button.layer.cornerRadius = 12
        return button
    }()

    private let bottomSheetView = AdminBottomSheetView()

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

        bottomSheetTestButton.rx.controlEvent([.touchUpInside])
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.showBottomSheet()
            }).disposed(by: disposeBag)
    }

    func bindViewModel() {

    }

}

// MARK: - BottomSheet
private extension AdminManagementViewController {

    func showBottomSheet() {
        view.addSubview(bottomSheetView)
        bottomSheetView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
    }

}

// MARK: - etc
private extension AdminManagementViewController {

    func setupDelegate() {

    }

    func setupNavigationTitle() {
        navigationTitleLabel.text = "YAPP 오리엔테이션"
    }

    func setupMessage() {
        adminMesasgeView.configureLabel("10명이 출석했어요")
    }

}

// MARK: - UI
private extension AdminManagementViewController {

    func configureUI() {
        view.backgroundColor = .white
    }

    func configureLayout() {
        view.addSubviews([adminMesasgeView, bottomSheetTestButton])

        adminMesasgeView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.topPadding)
            $0.left.right.equalToSuperview().inset(Constants.padding)
            $0.height.equalTo(48)
        }
        bottomSheetTestButton.snp.makeConstraints {
            $0.top.equalTo(adminMesasgeView.snp.bottom).offset(Constants.topPadding)
            $0.left.right.equalToSuperview().inset(Constants.padding)
            $0.height.equalTo(48)
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
            $0.left.equalToSuperview().offset(Constants.padding)
            $0.width.height.equalTo(24)
        }
    }

}
