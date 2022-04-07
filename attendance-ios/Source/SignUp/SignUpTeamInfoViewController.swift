//
//  SignUpTeamInfoViewController.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/03/03.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class SignUpTeamInfoViewController: UIViewController {

    enum Constants {
        static let padding: CGFloat = 24
        static let buttonHeight: CGFloat = 60

        static let cellHeight: CGFloat = 47
        static let cellSpacing: CGFloat = 12
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "소속 팀을 \n알려주세요"
        label.font = .Pretendard(type: .bold, size: 24)
        label.textColor = .gray_1200
        label.numberOfLines = 0
        return label
    }()

    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "하나만 더 알려주세요"
        label.font = .Pretendard(type: .bold, size: 18)
        label.textColor = .gray_1200
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    private let teamTypeCollectionView: UICollectionView = {
        let layout = CollectionViewLeftAlignFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    private let teamNumberCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isHidden = true
        return collectionView
    }()

    private let okButton: UIButton = {
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
private extension SignUpTeamInfoViewController {

    func bindViewModel() {
        viewModel.input.teamType
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.teamTypeCollectionView.reloadData()
            })
            .disposed(by: disposeBag)

        viewModel.input.teamNumber
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.teamNumberCollectionView.reloadData()
            })
            .disposed(by: disposeBag)

        viewModel.output.showTeamNumber
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.subTitleLabel.isHidden = false
                self?.teamNumberCollectionView.isHidden = false
            })
            .disposed(by: disposeBag)

        viewModel.output.complete
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.activateButton()
            })
            .disposed(by: disposeBag)

        viewModel.output.goToHome
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.goToHome()
            })
            .disposed(by: disposeBag)
    }

    func bindButton() {
        okButton.rx.controlEvent([.touchUpInside])
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
extension SignUpTeamInfoViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    private func setupCollectionView() {
        teamTypeCollectionView.delegate = self
        teamTypeCollectionView.dataSource = self
        teamNumberCollectionView.delegate = self
        teamNumberCollectionView.dataSource = self

        teamTypeCollectionView.register(SignUpCollectionViewCell.self, forCellWithReuseIdentifier: SignUpCollectionViewCell.identifier)
        teamNumberCollectionView.register(SignUpCollectionViewCell.self, forCellWithReuseIdentifier: SignUpCollectionViewCell.identifier)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let teamTypes = try? viewModel.output.configTeams.value() else { return 0 }

        switch collectionView {
        case teamTypeCollectionView: return teamTypes.count
        case teamNumberCollectionView:
            guard let teamType = try? viewModel.input.teamType.value(),
                  let countString = teamTypes.filter({ $0.team == teamType.rawValue }).first?.count,
                  let count = Int(countString) else { break }
            return count
        default: return 0
        }

        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SignUpCollectionViewCell.identifier, for: indexPath) as? SignUpCollectionViewCell,
                let teams = try? viewModel.output.configTeams.value() else { return UICollectionViewCell() }

        switch collectionView {
        case teamTypeCollectionView:
            cell.configureUI(text: teams[indexPath.row].team)
        case teamNumberCollectionView:
            cell.configureUI(text: "\(indexPath.row+1)팀")
            guard let teamNumber = try? viewModel.input.teamNumber.value() else { break }
            cell.configureUI(isSelected: teamNumber == indexPath.row+1)
        default: break
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dummyCell = SignUpCollectionViewCell(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: Constants.cellHeight))
        var text = ""

        switch collectionView {
        case teamTypeCollectionView:
            guard let teams = try? viewModel.output.configTeams.value() else { break }
            text = teams[indexPath.row].team
        case teamNumberCollectionView: text = "\(indexPath.row+1)팀"
        default: ()
        }

        dummyCell.configureUI(text: text)
        dummyCell.layoutIfNeeded()
        let estimatedSize = dummyCell.systemLayoutSizeFitting(CGSize(width: 80, height: Constants.cellHeight))
        return estimatedSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Constants.cellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        Constants.cellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let teamTypes = try? viewModel.output.configTeams.value().map({ $0.team }),
              let cell = collectionView.cellForItem(at: indexPath) as? SignUpCollectionViewCell else { return }
        switch collectionView {
        case teamTypeCollectionView:
            let teamType = TeamType(rawValue: teamTypes[indexPath.row])
            viewModel.input.teamType.onNext(teamType)
        case teamNumberCollectionView:
            viewModel.input.teamNumber.onNext(indexPath.row+1)
        default: break
        }
        cell.configureSelectedUI()
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SignUpCollectionViewCell else { return }
        cell.configureDeselectedUI()
    }

    final class CollectionViewLeftAlignFlowLayout: UICollectionViewFlowLayout {

        override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
            self.minimumLineSpacing = Constants.cellSpacing
            var leftMargin = sectionInset.left
            var maxY: CGFloat = -1.0

            attributes.forEach { attribute in
                if attribute.frame.origin.y >= maxY {
                    leftMargin = sectionInset.left
                }
                attribute.frame.origin.x = leftMargin
                leftMargin += attribute.frame.width + Constants.cellSpacing
                maxY = max(attribute.frame.maxY, maxY)
            }

            return attributes
        }

    }

}

// MARK: - etc
private extension SignUpTeamInfoViewController {

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
        okButton.isEnabled = true
        okButton.backgroundColor = UIColor.yapp_orange
    }

    func deactivateButton() {
        okButton.isEnabled = false
        okButton.backgroundColor = UIColor.gray_400
    }

    func configureUI() {
        view.backgroundColor = .white
    }

    func configureLayout() {
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(teamTypeCollectionView)
        view.addSubview(subTitleLabel)
        view.addSubview(teamNumberCollectionView)
        view.addSubview(okButton)

        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(56)
            $0.left.equalToSuperview().offset(Constants.padding)
            $0.width.height.equalTo(24)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(120)
            $0.left.right.equalToSuperview().inset(Constants.padding)
        }
        teamTypeCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(28)
            $0.left.equalToSuperview().inset(Constants.padding)
            $0.right.equalToSuperview().inset(Constants.padding*4)
            $0.height.equalTo(Constants.cellHeight*2+Constants.cellSpacing)
        }
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(teamTypeCollectionView.snp.bottom).offset(32)
            $0.left.right.equalToSuperview().inset(Constants.padding)
        }
        teamNumberCollectionView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(Constants.padding)
            $0.height.equalTo(Constants.cellHeight)
        }
        okButton.snp.makeConstraints {
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
