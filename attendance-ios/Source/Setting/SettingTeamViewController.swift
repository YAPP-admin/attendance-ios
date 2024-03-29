
//
//  SignUpTeamViewController.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/03/03.
//

import FirebaseFirestore
import KakaoSDKAuth
import KakaoSDKUser
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class SettingTeamViewController: UIViewController {

    enum Constants {
        static let padding: CGFloat = 24
        static let buttonHeight: CGFloat = 60

        static let cellHeight: CGFloat = 47
        static let cellSpacing: CGFloat = 12
        static let collectionViewHeightMargin: CGFloat = 4
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
        let layout = CollectionViewLeftAlignFlowLayout(cellSpacing: Constants.cellSpacing)
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .background
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        return collectionView
    }()

    private let teamNumberCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .background
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isHidden = true
        collectionView.isScrollEnabled = false
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

    private let alertView: AlertView = {
        let view = AlertView()
        view.isHidden = true
        view.configureUI(text: "입력을 취소할까요?", subText: "언제든 다시 돌아올 수 있어요", leftButtonText: "아니요", rightButtonText: "취소합니다")
        return view
    }()

    private var disposeBag = DisposeBag()
    private let viewModel: SettingViewModel

    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    init?(coder: NSCoder, viewModel: SettingViewModel) {
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
private extension SettingTeamViewController {
    
    func bindSubviews() {
        okButton.rx.controlEvent([.touchUpInside])
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.updateInfo()
                self?.dismiss()
            }).disposed(by: disposeBag)
        
        alertView.rightButton.rx.controlEvent([.touchUpInside])
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.alertView.isHidden.toggle()
                self?.dismiss()
            }).disposed(by: disposeBag)
    }
    
    func bindViewModel() {
        viewModel.input.teamType
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.teamNumberCollectionView.reloadData()
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
                self?.activateNextButton()
            })
            .disposed(by: disposeBag)
        
        viewModel.output.goToLoginVC
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss()
            })
            .disposed(by: disposeBag)
    }
    

}

// MARK: - CollectionView
extension SettingTeamViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    private func setupCollectionView() {
        teamTypeCollectionView.delegate = self
        teamTypeCollectionView.dataSource = self
        teamNumberCollectionView.delegate = self
        teamNumberCollectionView.dataSource = self

        teamTypeCollectionView.register(SignUpCollectionViewCell.self, forCellWithReuseIdentifier: SignUpCollectionViewCell.identifier)
        teamNumberCollectionView.register(SignUpCollectionViewCell.self, forCellWithReuseIdentifier: SignUpCollectionViewCell.identifier)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let teams = try? viewModel.output.configTeams.value() else { return 0 }

        switch collectionView {
        case teamTypeCollectionView: return teams.count
        case teamNumberCollectionView:
            guard let teamType = try? viewModel.input.teamType.value(), let team = teams.first(where: { $0.type == teamType }) else { return 0 }
            return team.number
        default: return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SignUpCollectionViewCell.identifier, for: indexPath) as? SignUpCollectionViewCell,
                let teams = try? viewModel.output.configTeams.value() else { return UICollectionViewCell() }

        switch collectionView {
        case teamTypeCollectionView:
            cell.configureUI(text: teams[indexPath.row].type.lowerCase)
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
            text = teams[indexPath.row].type.lowerCase
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
        guard let teams = try? viewModel.output.configTeams.value(),
              let cell = collectionView.cellForItem(at: indexPath) as? SignUpCollectionViewCell else { return }
        switch collectionView {
        case teamTypeCollectionView: viewModel.input.teamType.onNext(teams[indexPath.row].type)
        case teamNumberCollectionView: viewModel.input.teamNumber.onNext(indexPath.row+1)
        default: break
        }
        cell.didSelect()
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SignUpCollectionViewCell else { return }
        cell.didDeselect()
    }

}

// MARK: - etc
private extension SettingTeamViewController {

    func dismiss() {
        dismiss(animated: true)
    }
}

// MARK: - UI
private extension SettingTeamViewController {

    func activateNextButton() {
        okButton.isEnabled = true
        okButton.backgroundColor = UIColor.yapp_orange
    }

    func deactivateNextButton() {
        okButton.isEnabled = false
        okButton.backgroundColor = UIColor.gray_400
    }

    func configureUI() {
        view.backgroundColor = .background
    }

    func configureLayout() {
        view.addSubviews([titleLabel, teamTypeCollectionView, subTitleLabel, teamNumberCollectionView, okButton])

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(120)
            $0.left.right.equalToSuperview().inset(Constants.padding)
        }
        teamTypeCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(28)
            $0.left.equalToSuperview().inset(Constants.padding)
            $0.width.equalTo(260)
            $0.height.equalTo(Constants.cellHeight*2+Constants.cellSpacing+Constants.collectionViewHeightMargin)
        }
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(teamTypeCollectionView.snp.bottom).offset(32)
            $0.left.right.equalToSuperview().inset(Constants.padding)
        }
        teamNumberCollectionView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(Constants.padding)
            $0.height.equalTo(Constants.cellHeight+Constants.collectionViewHeightMargin)
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
