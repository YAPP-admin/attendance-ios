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
        let name = BehaviorSubject<String>(value: "")
        let positionIndex = BehaviorSubject<Int>(value: 0)
        let teamIndex = BehaviorSubject<Int>(value: 0)
    }

    struct Output {
        let isNameTextFieldValid = BehaviorSubject(value: false)
        let showTeamList = PublishRelay<Void>()
        let complete = PublishRelay<Void>()
    }

    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()

    let positions: [String] = ["All-Rounder", "Android", "iOS", "Web"]
    let teamCount: Int = 2

    init() {
        input.name
            .subscribe(onNext: { [weak self] name in
                self?.output.isNameTextFieldValid.onNext(!name.isEmpty)
            }).disposed(by: disposeBag)

        input.positionIndex
            .subscribe(onNext: { [weak self] _ in
                self?.output.showTeamList.accept(())
            }).disposed(by: disposeBag)

        input.teamIndex
            .subscribe(onNext: { [weak self] _ in
                self?.output.complete.accept(())
            }).disposed(by: disposeBag)
    }

}
