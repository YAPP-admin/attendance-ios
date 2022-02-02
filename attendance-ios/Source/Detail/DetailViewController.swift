//
//  DetailViewController.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/02/01.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class DetailViewController: UIViewController {
    
    private let viewModel = LoginViewModel()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureNavigationBar()
        bindViewModel()
        addSubViews()

    }
}

private extension DetailViewController {
    
    func bindViewModel() {
        
    }
    
    func addSubViews() {

    }
    
    func configureNavigationBar() {
        let ellipsisButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(showPolicyVC))
        ellipsisButton.tintColor = .black
        navigationItem.rightBarButtonItem = ellipsisButton
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .black
    }
    
    @objc func showPolicyVC() {
        let policyVC = PolicyViewController()
        self.navigationController?.pushViewController(policyVC, animated: true)
    }
}
