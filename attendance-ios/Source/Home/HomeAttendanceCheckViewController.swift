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
    let navigationBarView: BaseNavigationBarView = {
        let bar = BaseNavigationBarView(title: "출결 점수 확인")
        bar.hideBackButton()
		bar.titleLabel.textAlignment = .center
        return bar
    }()
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(HomeTotalScoreTableViewCell.self, forCellReuseIdentifier: "HomeTotalScoreTableViewCell")
        tableView.register(HomeAttendanceCheckTableViewCell.self, forCellReuseIdentifier: "HomeAttendanceCheckTableViewCell")
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .background
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .gray_200
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        tableView.separatorInsetReference = .fromAutomaticInsets
        return tableView
    }()

    var viewModel = HomeViewModel()
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        navigationController?.isNavigationBarHidden = true

        addSubViews()
        setupTableView()
        bindView()
    }

    func addSubViews() {
        view.addSubview(navigationBarView)
        view.addSubview(tableView)
        navigationBarView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom).offset(11)
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
            let status = data.attendances[indexPath.row - 1].status
            let item = viewModel.output.sessionList.value[indexPath.row - 1]
            let detailVC = HomeAttendanceDetailViewController()
            detailVC.setType(item, status: status)
            self.navigationController?.pushViewController(detailVC, animated: true)
		}
	}

	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if indexPath.row == 0 || indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
			cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
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
                cell.updateUI(viewModel.output.sessionList.value[indexPath.row - 1], status: data.attendances[indexPath.row - 1].status)
                return cell
            }
        }
        return UITableViewCell()
    }
}
