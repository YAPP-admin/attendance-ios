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
        label.font = .Pretendard(type: .Bold, size: 24)
        label.textColor = .gray_1200
        label.numberOfLines = 0
        return label
    }()

    private let jobCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    private let teamCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    private let okButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.titleLabel?.font = .Pretendard(type: .Bold, size: 18)
        button.backgroundColor = .gray_400
        button.layer.cornerRadius = 10
        button.isEnabled = false
        return button
    }()

    // TODO: - 파이어베이스 연동 필요
    private let jobs: [String] = ["All-Rounder", "Android", "iOS", "Web"]
    private let teamCount: Int = 2

    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindButton()
        setupDelegate()
        setupCollectionView()
        configureUI()
        configureLayout()
    }

}

extension SignUpTeamInfoViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        jobs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SignUpCollectionViewCell.identifier, for: indexPath) as? SignUpCollectionViewCell else { return UICollectionViewCell() }
        cell.configureUI(text: jobs[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dummyCell = SignUpCollectionViewCell(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: Constants.cellHeight))
        dummyCell.configureUI(text: jobs[indexPath.row])
        dummyCell.layoutIfNeeded()

        let estimatedSize = dummyCell.systemLayoutSizeFitting(CGSize(width: 100, height: Constants.cellHeight))
        return estimatedSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Constants.cellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        Constants.cellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SignUpCollectionViewCell else { return }
        cell.configureSelectedUI()
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SignUpCollectionViewCell else { return }
        cell.configureDeselectedUI()
    }

}

private extension SignUpTeamInfoViewController {

    func bindButton() {
        okButton.rx.controlEvent([.touchUpInside])
            .asObservable()
            .subscribe(onNext: { _ in
            }).disposed(by: disposeBag)
    }

    func setupDelegate() {

    }

    func setupCollectionView() {
        jobCollectionView.delegate = self
        teamCollectionView.delegate = self
        jobCollectionView.dataSource = self
        teamCollectionView.dataSource = self

        jobCollectionView.register(SignUpCollectionViewCell.self, forCellWithReuseIdentifier: SignUpCollectionViewCell.identifier)
        teamCollectionView.register(SignUpCollectionViewCell.self, forCellWithReuseIdentifier: SignUpCollectionViewCell.identifier)
    }

    func configureUI() {
        view.backgroundColor = .white
    }

    func configureLayout() {
        view.addSubview(titleLabel)
        view.addSubview(jobCollectionView)
        view.addSubview(okButton)

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            $0.left.right.equalToSuperview().inset(Constants.padding)
        }
        jobCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(28)
            $0.left.equalToSuperview().inset(Constants.padding)
            $0.right.equalToSuperview().inset(Constants.padding*6)
            $0.height.equalTo(Constants.cellHeight*2+Constants.cellSpacing)
        }
        okButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(Constants.padding)
            $0.bottom.equalToSuperview().inset(40)
            $0.height.equalTo(Constants.buttonHeight)
        }
    }

}
