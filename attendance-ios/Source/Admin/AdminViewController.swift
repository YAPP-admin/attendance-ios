//
//  AdminViewController.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/03/16.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class AdminViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupDelegate()
        configureUI()
        configureLayout()
    }

}

private extension AdminViewController {

    func bindViewModel() {

    }

    func setupDelegate() {

    }

    func configureUI() {
        view.backgroundColor = .yapp_orange
    }

    func configureLayout() {

    }

}
