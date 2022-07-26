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
        static let collectionViewHeightMargin: CGFloat = 12
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "속한 직군을 \n알려주세요"
        label.font = .Pretendard(type: .bold, size: 24)
        label.textColor = .gray_1200
        label.setLineSpacing(4)
        label.numberOfLines = 0
        return label
    }()

    private let collectionView: UICollectionView = {
        let layout = CollectionViewLeftAlignFlowLayout(cellSpacing: Constants.cellSpacing)
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        return collectionView
    }()

    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = .Pretendard(type: .bold, size: 18)
        button.backgroundColor = .gray_400
        button.layer.cornerRadius = 10
        button.isEnabled = false
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
        bindButton()

        setupDelegate()
        setupCollectionView()

        configureUI()
        configureLayout()
        configureAlertViewLayout()
        addNavigationBackButton()
    }

    override func navigationBackButtonTapped() {
        alertView.isHidden.toggle()
    }

}

// MARK: - Bind
private extension SignUpPositionViewController {

    func bindButton() {
        nextButton.rx.controlEvent([.touchUpInside])
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.goToTeamVC()
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
        return PositionType.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SignUpCollectionViewCell.identifier, for: indexPath) as? SignUpCollectionViewCell else { return UICollectionViewCell() }
        cell.configureUI(text: PositionType.allCases[indexPath.row].shortValue)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dummyCell = SignUpCollectionViewCell(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: Constants.cellHeight))
        let text = PositionType.allCases[indexPath.row].shortValue
        dummyCell.configureUI(text: text)
        dummyCell.layoutIfNeeded()
        let estimatedSize = dummyCell.systemLayoutSizeFitting(CGSize(width: 80, height: Constants.cellHeight))
        return estimatedSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.cellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.cellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SignUpCollectionViewCell else { return }
        let positionType = PositionType.allCases[indexPath.row]
        viewModel.input.positionType.onNext(positionType)
        cell.didSelect()
        activateNextButton()
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SignUpCollectionViewCell else { return }
        cell.didDeselect()
    }

}

// MARK: - etc
private extension SignUpPositionViewController {

    func goToHome() {
        let homeVC = HomeViewController()
		navigationController?.pushViewController(homeVC, animated: true)
    }

    func goToLogin() {
        navigationController?.popToRootViewController(animated: true)
    }

    func goToTeamVC() {
        let teamVC = SignUpTeamViewController(viewModel: viewModel)
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.isHidden = true
        navigationController?.pushViewController(teamVC, animated: true)
    }

    func setupDelegate() {

    }

    func activateNextButton() {
        nextButton.isEnabled = true
        nextButton.backgroundColor = UIColor.yapp_orange
    }

    func deactivateNextButton() {
        nextButton.isEnabled = false
        nextButton.backgroundColor = UIColor.gray_400
    }

    func configureUI() {
        view.backgroundColor = .white
    }

    func configureLayout() {
        view.addSubviews([titleLabel, collectionView, nextButton])

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(120)
            $0.left.right.equalToSuperview().inset(Constants.padding)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(28)
            $0.left.equalToSuperview().inset(Constants.padding)
            $0.width.equalTo(250)
            $0.height.equalTo(Constants.cellHeight*3+Constants.cellSpacing*2+Constants.collectionViewHeightMargin)
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
