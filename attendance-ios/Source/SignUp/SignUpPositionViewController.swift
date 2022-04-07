//
//  SignUpPositionViewController.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/04/07.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class SignUpPositionViewController: UIViewController {

    enum Constants {
        static let padding: CGFloat = 24
        static let buttonHeight: CGFloat = 60

        static let cellHeight: CGFloat = 47
        static let cellSpacing: CGFloat = 12
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "속한 직군을 \n알려주세요"
        label.font = .Pretendard(type: .bold, size: 24)
        label.textColor = .gray_1200
        label.numberOfLines = 0
        return label
    }()

    private let collectionView: UICollectionView = {
        let layout = CollectionViewLeftAlignFlowLayout(cellSpacing: Constants.cellSpacing)
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.titleLabel?.font = .Pretendard(type: .bold, size: 18)
        button.backgroundColor = .gray_400
        button.layer.cornerRadius = 10
        button.isEnabled = false
        return button
    }()

    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "back"), for: .normal)
        return button
    }()

    private let alertView: AlertView = {
        let view = AlertView()
        view.isHidden = true
        view.configureUI(text: "입력을 취소할까요?", subText: "언제든 다시 돌아올 수 있어요", leftButtonText: "아니요", rightButtonText: "취소합니다")
        return view
    }()

    private var disposeBag = DisposeBag()
    private let viewModel: SignUpViewModel

    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    init?(coder: NSCoder, viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        bindButton()
        setupDelegate()
        setupCollectionView()
        configureUI()
        configureLayout()
        configureAlertViewLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
    }

}

// MARK: - Bind
private extension SignUpPositionViewController {

    func bindViewModel() {

    }

    func bindButton() {
        nextButton.rx.controlEvent([.touchUpInside])
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.registerInfo()
            }).disposed(by: disposeBag)

        backButton.rx.controlEvent([.touchUpInside])
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.alertView.isHidden.toggle()
            }).disposed(by: disposeBag)

        alertView.rightButton.rx.controlEvent([.touchUpInside])
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.alertView.isHidden.toggle()
                self?.goToLogin()
            }).disposed(by: disposeBag)
    }

}

// MARK: - CollectionView
extension SignUpPositionViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(SignUpCollectionViewCell.self, forCellWithReuseIdentifier: SignUpCollectionViewCell.identifier)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Constants.cellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        Constants.cellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

    }

}

// MARK: - etc
private extension SignUpPositionViewController {

    func goToHome() {
        let homeVC = HomeViewController()
        homeVC.modalPresentationStyle = .fullScreen
        self.present(homeVC, animated: true, completion: nil)
    }

    func goToLogin() {
        navigationController?.popToRootViewController(animated: true)
    }

    func setupDelegate() {

    }

    func activateButton() {
        nextButton.isEnabled = true
        nextButton.backgroundColor = UIColor.yapp_orange
    }

    func deactivateButton() {
        nextButton.isEnabled = false
        nextButton.backgroundColor = UIColor.gray_400
    }

    func configureUI() {
        view.backgroundColor = .white
    }

    func configureLayout() {
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        view.addSubview(nextButton)

        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(56)
            $0.left.equalToSuperview().offset(Constants.padding)
            $0.width.height.equalTo(24)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(120)
            $0.left.right.equalToSuperview().inset(Constants.padding)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(28)
            $0.left.equalToSuperview().inset(Constants.padding)
            $0.right.equalToSuperview().inset(Constants.padding*4)
            $0.height.equalTo(Constants.cellHeight*2+Constants.cellSpacing)
        }
        nextButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(Constants.padding)
            $0.bottom.equalToSuperview().inset(40)
            $0.height.equalTo(Constants.buttonHeight)
        }
    }

    func configureAlertViewLayout() {
        view.addSubview(alertView)

        alertView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
    }

}
