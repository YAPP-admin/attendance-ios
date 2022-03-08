//
//  SignUpViewModel.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/03/08.
//

import RxCocoa
import RxSwift
import UIKit

final class SignUpViewModel: ViewModel {
    struct Input {
        let name = PublishSubject<String>()
        let jobIndex = PublishSubject<Int>()
        let teamIndex = PublishSubject<Int>()
    }

    struct Output {
        let isNameTextFieldValid = BehaviorSubject(value: false)
    }

    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()

    let jobs: [String] = ["All-Rounder", "Android", "iOS", "Web"]
    let teamCount: Int = 2

    init() {
        input.name
            .subscribe(onNext: { [weak self] name in
                self?.output.isNameTextFieldValid.onNext(!name.isEmpty)
            }).disposed(by: disposeBag)
    }

}
