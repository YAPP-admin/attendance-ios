//
//  HomeViewModel.swift
//  attendance-ios
//
//  Created by 김보민 on 2022/03/03.
//

import RxCocoa
import RxSwift
import UIKit

final class HomeViewModel: ViewModel {
    struct Input {
        let tapQR = PublishRelay<Void>()
    }

    struct Output {
        var goToQR = PublishRelay<Void>()
    }

    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()

    init() {
        input.tapQR
            .subscribe(onNext: { [weak self] _ in
                self?.output.goToQR.accept(())
            }).disposed(by: disposeBag)
    }
}
