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

        let selectedTeamIndexListInGrade = BehaviorSubject<[Int]>(value: [])
        let selectedMemberInManagement = BehaviorSubject<Member?>(value: nil)
        let selectedAttenceInManagement = BehaviorSubject<AttendanceType?>(value: nil)
    }

    struct Output {
        let memberList = BehaviorSubject<[Member]>(value: [])
        let sessionList = BehaviorSubject<[Session]>(value: [])
        let teamList = BehaviorSubject<[Team]>(value: [])
        let todaySession = BehaviorSubject<Session?>(value: nil)

        let showBottomsheet = PublishRelay<Void>()
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
        subscribeOutputs()

        setupMemberList()
        setupSessionList()
        setupTeamList()
    }

}

// MARK: - Bind
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

        input.selectedMemberInManagement
            .subscribe(onNext: { [weak self] _ in
                self?.output.showBottomsheet.accept(())
            }).disposed(by: disposeBag)
    }

    func subscribeOutputs() {
        output.sessionList
            .subscribe(onNext: { [weak self] _ in
                self?.setupTodaySession()
            }).disposed(by: disposeBag)
    }

}

// MARK: - Setup
private extension AdminViewModel {

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

    func setupTeamList() {
        configWorker.decodeSelectTeams { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let teams):
                let allTeams = self.makeTeamList(teams)
                self.output.teamList.onNext(allTeams)
            case .failure: ()
            }
        }
    }

    private func makeTeamList(_ teams: [Team]) -> [Team] {
        var newTeams: [Team] = []
        teams.forEach {
            for n in 1...$0.number {
                let team = Team(type: $0.type, number: n)
                newTeams.append(team)
            }
        }
        return newTeams
    }

    func setupTodaySession() {
        guard let sessionList = try? output.sessionList.value() else { return }
        let todaySession = sessionList.todaySession()
        output.todaySession.onNext(todaySession)
    }

}
