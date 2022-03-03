//
//  HomeViewController.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/01/31.
//

import AVFoundation
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class HomeViewController: UIViewController {
    private let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

	private let settingButton: UIButton = {
		let button = UIButton()
		button.backgroundColor = .clear
		button.setImage(UIImage(named: "setting"), for: .normal)
		button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		return button
	}()

    private lazy var tabView: HomeBottomTabView = {
        let view = HomeBottomTabView()
        return view
    }()

    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let oneView: UIView = {
        let view = UIView()
        view.backgroundColor = .red.withAlphaComponent(0.1)
        return view
    }()
    private let twoView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen.withAlphaComponent(0.1)
        return view
    }()
    private let threeView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue.withAlphaComponent(0.1)
        return view
    }()

    private let viewModel = BaseViewModel()
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        navigationController?.isNavigationBarHidden = true

        addSubViews()
    }

    func addSubViews() {
        view.addSubview(topView)
        topView.addSubview(settingButton)
        view.addSubview(tabView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        topView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        settingButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-14)
            $0.width.height.equalTo(44)
        }
        tabView.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.height.equalTo(100)
        }

        contentView.addSubview(oneView)
        contentView.addSubview(twoView)
        contentView.addSubview(threeView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(tabView.snp.top)
        }
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.greaterThanOrEqualToSuperview()
        }
        oneView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.equalTo(400)
            $0.leading.trailing.equalToSuperview()
        }
        twoView.snp.makeConstraints {
            $0.top.equalTo(oneView.snp.bottom).offset(10)
            $0.height.equalTo(400)
            $0.leading.trailing.equalToSuperview()
        }
        threeView.snp.makeConstraints {
            $0.top.equalTo(twoView.snp.bottom).offset(10)
            $0.height.equalTo(400)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
    }
}
