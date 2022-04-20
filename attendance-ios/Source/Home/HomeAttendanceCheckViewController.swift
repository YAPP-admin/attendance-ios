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
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(HomeAttendanceCheckTableViewCell.self, forCellReuseIdentifier: "HomeAttendanceCheckTableViewCell")
        tableView.register(HomeTotalScoreTableViewCell.self, forCellReuseIdentifier: "HomeTotalScoreTableViewCell")
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true

        addSubViews()
        bindView()
    }

    func addSubViews() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(11)
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }

    func bindView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension HomeAttendanceCheckViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension HomeAttendanceCheckViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTotalScoreTableViewCell", for: indexPath) as? HomeTotalScoreTableViewCell {
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeAttendanceCheckTableViewCell", for: indexPath) as? HomeAttendanceCheckTableViewCell {
                
                return cell
            }
        }
        return UITableViewCell()
    }
}
