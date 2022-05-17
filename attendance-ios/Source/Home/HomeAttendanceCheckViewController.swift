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
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(HomeTotalScoreTableViewCell.self, forCellReuseIdentifier: "HomeTotalScoreTableViewCell")
        tableView.register(HomeAttendanceCheckTableViewCell.self, forCellReuseIdentifier: "HomeAttendanceCheckTableViewCell")
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .gray_200
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        tableView.separatorInsetReference = .fromAutomaticInsets
        return tableView
    }()

    var viewModel = HomeViewModel()
    private var disposeBag = DisposeBag()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel.calculateScore()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true

        addSubViews()
        setupTableView()
        bindView()
    }

    func addSubViews() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(11)
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    func bindView() {
        viewModel.output.sessionList
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                UIView.performWithoutAnimation {
                    self?.tableView.reloadData()
                }
            }).disposed(by: disposeBag)

        viewModel.memberData
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                UIView.performWithoutAnimation {
                    self?.tableView.reloadData()
                }
            }).disposed(by: disposeBag)

        viewModel.output.totalScore
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                UIView.performWithoutAnimation {
                    self?.tableView.reloadData()
                }
            }).disposed(by: disposeBag)
    }

    private func showHelpVC() {
        let helpVC = HelpViewController()
        self.navigationController?.pushViewController(helpVC, animated: true)
    }
}

extension HomeAttendanceCheckViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            guard let data = viewModel.memberData.value else { return }
            let type = data.attendances[indexPath.row - 1].type
            let item = viewModel.output.sessionList.value[indexPath.row - 1]
            let detailVC = HomeAttendanceDetailViewController()
            detailVC.setType(item, type: type)
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

extension HomeAttendanceCheckViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.sessionList.value.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTotalScoreTableViewCell", for: indexPath) as? HomeTotalScoreTableViewCell {
                cell.updateUI(total: viewModel.output.totalScore.value, attendance: viewModel.output.attendanceScore.value, absence: viewModel.output.absenceScore.value, tardy: viewModel.output.tardyScore.value)
                cell.helpButton.rx.tap
                    .subscribe(onNext: { [weak self] _ in
                        guard let self = self else { return }
                        self.showHelpVC()
                    }).disposed(by: cell.eventBag)
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeAttendanceCheckTableViewCell", for: indexPath) as? HomeAttendanceCheckTableViewCell {
                guard let data = viewModel.memberData.value else { return cell }
                cell.updateUI(viewModel.output.sessionList.value[indexPath.row - 1], data: data.attendances[indexPath.row - 1].type)
                return cell
            }
        }
        return UITableViewCell()
    }
}
