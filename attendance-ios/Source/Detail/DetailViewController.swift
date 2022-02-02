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
        navigationController?.navigationBar.tintColor = .black
        
        bindViewModel()
        addSubViews()
    }
}

private extension DetailViewController {
    
    func bindViewModel() {
        
    }
    
    func addSubViews() {

    }
}
