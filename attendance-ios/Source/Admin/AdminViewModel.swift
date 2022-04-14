//
//  AdminViewModel.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/03/16.
//

import FirebaseRemoteConfig
import RxCocoa
import RxSwift
import UIKit
final class AdminViewModel: ViewModel {

    struct Input {
        let tapCardView = PublishRelay<Void>()
        let tapManagementButton = PublishRelay<Void>()
        let tapSettingButton = PublishRelay<Void>()
    }

    struct Output {
        let goToGradeVC = PublishRelay<Void>()
        let goToManagementVC = PublishRelay<Void>()
        let goToSettingVC = PublishRelay<Void>()
    }

    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()

    init() {
        subscribeInputs()
    }

    private func subscribeInputs() {
        input.tapCardView
            .subscribe(onNext: { [weak self] _ in
                self?.output.goToGradeVC.accept(())
            }).disposed(by: disposeBag)

        input.tapManagementButton
            .subscribe(onNext: { [weak self] _ in
                self?.output.goToManagementVC.accept(())
            }).disposed(by: disposeBag)

        input.tapSettingButton
            .subscribe(onNext: { [weak self] _ in
                self?.output.goToSettingVC.accept(())
            }).disposed(by: disposeBag)
    }

}
