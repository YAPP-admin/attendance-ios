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
        let tapLogoutButton = PublishRelay<Void>()

        let selectedIndexInManagement = BehaviorSubject<Int?>(value: nil)
        let selectedAttenceInManagement = BehaviorSubject<AttendanceType?>(value: nil)
    }

    struct Output {
        let memberList = BehaviorSubject<[Member]>(value: [])
        let sessionList = BehaviorSubject<[Session]>(value: [])
        let goToLoginVC = PublishRelay<Void>()
        let goToGradeVC = PublishRelay<Void>()
        let goToManagementVC = PublishRelay<Void>()
    }

    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()
    private let firebaseWorker = FirebaseWorker()
    private let configWorker = ConfigWorker()

    init() {
        subscribeInputs()
        setupMemberList()
        setupSessionList()
    }

}

private extension AdminViewModel {

    func subscribeInputs() {
        input.tapCardView
            .subscribe(onNext: { [weak self] _ in
                self?.output.goToGradeVC.accept(())
            }).disposed(by: disposeBag)

        input.tapManagementButton
            .subscribe(onNext: { [weak self] _ in
                self?.output.goToManagementVC.accept(())
            }).disposed(by: disposeBag)

        input.tapLogoutButton
            .subscribe(onNext: { [weak self] _ in
                self?.output.goToLoginVC.accept(())
            }).disposed(by: disposeBag)
    }

    func setupMemberList() {
        firebaseWorker.getAllMembers { [weak self] result in
            switch result {
            case .success(let list): self?.output.memberList.onNext(list)
            case .failure: ()
            }
        }
    }

    func setupSessionList() {
        configWorker.decodeSessionList { [weak self] result in
            switch result {
            case .success(let list): self?.output.sessionList.onNext(list)
            case .failure: ()
            }
        }
    }

}
