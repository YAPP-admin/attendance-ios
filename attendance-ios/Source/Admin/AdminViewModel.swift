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
    }

    struct Output {
        let goToGradeVC = PublishRelay<Void>()
    }

    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()

    init() {
        input.tapCardView
            .subscribe(onNext: { [weak self] _ in
                self?.output.goToGradeVC.accept(())
            }).disposed(by: disposeBag)
    }

}

private extension AdminViewModel {

}
