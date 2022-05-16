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
        let tapLogoutView = PublishRelay<Void>()
        let tapMemberView = PublishRelay<Void>()
    }

    struct Output {
        var goToHome = PublishRelay<Void>()
        let goToPolicyVC = PublishRelay<Void>()
        let goToLoginVC = PublishRelay<Void>()
        var generation = BehaviorRelay<String>(value: "")
    }

    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()
    let db = Firestore.firestore()
    var documentID = BehaviorRelay<String>(value: "")
    var memberData = BehaviorRelay<Member?>(value: nil)

    private let userDefaultsWorker = UserDefaultsWorker()
    private let firebaseWorker = FirebaseWorker()

    init() {
        input.tapBack
            .subscribe(onNext: { [weak self] _ in
                self?.output.goToHome.accept(())
            }).disposed(by: disposeBag)

        input.tapPolicyView
            .subscribe(onNext: { [weak self] _ in
                self?.output.goToPolicyVC.accept(())
            }).disposed(by: disposeBag)

        input.tapLogoutView
            .subscribe(onNext: { [weak self] _ in
                self?.logout()
            }).disposed(by: disposeBag)

        input.tapMemberView
            .subscribe(onNext: { [weak self] _ in
                self?.memberOut()
            }).disposed(by: disposeBag)

        checkGeneration()
    }

    func checkGeneration() {
        if let generation = userDefaultsWorker.getGeneration(), generation.isEmpty == false {
            output.generation.accept(generation)
        }
    }

    func logout() {
        userDefaultsWorker.removeKakaoTalkId()
        output.goToLoginVC.accept(())
    }

    func memberOut() {
        guard let member = memberData.value else { return }

        firebaseWorker.deleteDocument(memberId: member.id) { [weak self] _ in
            guard let self = self else { return }
            self.userDefaultsWorker.removeKakaoTalkId()
            self.output.goToLoginVC.accept(())
        }
    }
}
