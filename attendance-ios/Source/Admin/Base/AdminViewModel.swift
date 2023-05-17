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
    enum SegmentType: Int {
        case team
        case position
    }
    
    struct Input {
        let tapCardView = PublishRelay<Void>()
        let tapLogoutButton = PublishRelay<Void>()

        let selectedSegmentControl = BehaviorSubject<Int>(value: 0)
        let selectedTeamIndexListInGrade = BehaviorSubject<[Int]>(value: [])
        let selectedTeamIndexListInManagement = BehaviorSubject<[Int]>(value: [])
        let selectedMemberInManagement = BehaviorSubject<Member?>(value: nil)
    }

    struct Output {
        let memberList = BehaviorSubject<[Member]>(value: [])
        let sessionList = BehaviorSubject<[Session]>(value: [])
        let itemList = BehaviorSubject<[DisplayableItem]>(value: [])
        let todaySession = BehaviorSubject<Session?>(value: nil)
        let isFinished = BehaviorSubject<Bool>(value: false)

        let showBottomsheet = PublishRelay<Void>()
        let goToLoginVC = PublishRelay<Void>()
        let goToGradeVC = PublishRelay<Void>()
    }

    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()
    private let firebaseWorker = FirebaseWorker()
    private let configWorker = ConfigWorker.shared

    init() {
        subscribeInputs()
        subscribeOutputs()
        setupMemberList()
        setupSessionList()
    }
    
    func setup(segmentType: SegmentType) {
        switch segmentType {
        case .team:
            setupTeamList()
        case .position:
            setupPositionList()
        }
    }

}

// MARK: - Update
extension AdminViewModel {

    func updateAttendances(memberId: Int, attendances: [Attendance]) {
        firebaseWorker.updateMemberAttendances(memberId: memberId, attendances: attendances)

        guard var memberList = try? output.memberList.value(),
              let index = memberList.firstIndex(where: { $0.id == memberId }) else { return }
        memberList[index].attendances = attendances
        output.memberList.onNext(memberList)
    }

}

// MARK: - Bind
private extension AdminViewModel {

    func subscribeInputs() {
        input.tapCardView
            .subscribe(onNext: { [weak self] _ in
                self?.output.goToGradeVC.accept(())
            }).disposed(by: disposeBag)

        input.tapLogoutButton
            .subscribe(onNext: { [weak self] _ in
                self?.output.goToLoginVC.accept(())
            }).disposed(by: disposeBag)

        input.selectedMemberInManagement
            .subscribe(onNext: { [weak self] _ in
                self?.output.showBottomsheet.accept(())
            }).disposed(by: disposeBag)
        
        input.selectedSegmentControl
            .subscribe(onNext: { [weak self] idx in
                self?.input.selectedTeamIndexListInGrade.onNext([])
                self?.input.selectedTeamIndexListInGrade.onNext([])
                self?.setup(segmentType: SegmentType(rawValue: idx) ?? .team)
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
                self.output.itemList.onNext(allTeams)
            case .failure: ()
            }
        }
    }
    
    func setupPositionList() {
        output.itemList.onNext(Position.allCases)
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
        guard let sessionList = try? output.sessionList.value(), sessionList.isEmpty == false else { return }
        let todaySession = sessionList.todaySession()
        output.todaySession.onNext(todaySession)
        output.isFinished.onNext(todaySession == nil)
    }

}
