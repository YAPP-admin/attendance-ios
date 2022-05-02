//
//  SettingViewModel.swift
//  attendance-ios
//
//  Created by 김보민 on 2022/03/30.
//

import RxCocoa
import RxSwift
import UIKit
import FirebaseFirestore

final class SettingViewModel: ViewModel {
    struct Input {
        let tapBack = PublishRelay<Void>()
        let tapPolicyView = PublishRelay<Void>()
    }

    struct Output {
        var goToHome = PublishRelay<Void>()
        let goToPolicyVC = PublishRelay<Void>()
        var generation = BehaviorRelay<String>(value: "")
    }

    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()
    let db = Firestore.firestore()
    var documentID = BehaviorRelay<String>(value: "")
    var memberData = BehaviorRelay<Member?>(value: nil)

    private let userDefaultsWorker = UserDefaultsWorker()

    init() {
        input.tapBack
            .subscribe(onNext: { [weak self] _ in
                self?.output.goToHome.accept(())
            }).disposed(by: disposeBag)

        input.tapPolicyView
            .subscribe(onNext: { [weak self] _ in
                self?.output.goToPolicyVC.accept(())
            }).disposed(by: disposeBag)

        checkGeneration()
    }

    func checkGeneration() {
        if let generation = userDefaultsWorker.getGeneration(), generation.isEmpty == false {
            output.generation.accept(generation)
        }
    }
}
