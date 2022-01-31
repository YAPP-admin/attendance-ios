//
//  HomeViewController.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/01/31.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class HomeViewController: UIViewController {
    
    private let viewModel = LoginViewModel()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        navigationItem.hidesBackButton = true
        
        bindViewModel()
        addSubViews()
    }
}

private extension HomeViewController {
    
    func bindViewModel() {
        
    }
    
    func addSubViews() {
        
    }
}
