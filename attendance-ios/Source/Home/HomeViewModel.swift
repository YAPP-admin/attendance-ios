//
//  HomeViewModel.swift
//  attendance-ios
//
//  Created by 김보민 on 2022/03/03.
//

import RxCocoa
import RxSwift
import UIKit

enum HomeType: Int {
    case todaySession = 0
    case attendanceCheck
}

final class HomeViewModel: ViewModel {
    struct Input {
        let tapQR = PublishRelay<Void>()
        let tapSetting = PublishRelay<Void>()
        let tapBack = PublishRelay<Void>()
    }

    struct Output {
        let sessionList = BehaviorRelay<[Session]>(value: [])
        let goToQR = PublishRelay<Void>()
        let goToSetting = PublishRelay<Void>()
        let goToHome = PublishRelay<Void>()
        let goToLoginVC = PublishRelay<Void>()
        let hasError = BehaviorRelay<Bool>(value: false)
		let isReload = BehaviorRelay<Bool>(value: false)
        let yappConfig = BehaviorSubject<YappConfig?>(value: nil)

        let kakaoAccessToken = PublishSubject<String>()
        let kakaoTalkId = BehaviorSubject<String>(value: "")
        let appleId = BehaviorSubject<String>(value: "")

        let totalScore = BehaviorRelay<Int>(value: 0)
        let attendanceScore = BehaviorRelay<Int>(value: 0)
        let absenceScore = BehaviorRelay<Int>(value: 0)
        let tardyScore = BehaviorRelay<Int>(value: 0)
    }

    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()
    let configWorker = ConfigWorker()
    let homeType = BehaviorRelay<HomeType>(value: .todaySession)
    let myId = BehaviorRelay<String>(value: "")
    let memberData = BehaviorRelay<Member?>(value: nil)
	let currentType = BehaviorRelay<AttendanceType>(value: .absence)
    let isRefreshing = BehaviorRelay<Bool>(value: false)
	let isGuest = BehaviorRelay<Bool>(value: false)

    private let userDefaultsWorker = UserDefaultsWorker()
    private let firebaseWorker = FirebaseWorker()

    init() {
        input.tapQR
            .subscribe(onNext: { [weak self] _ in
                self?.output.goToQR.accept(())
            }).disposed(by: disposeBag)

        input.tapSetting
            .subscribe(onNext: { [weak self] _ in
                self?.output.goToSetting.accept(())
            }).disposed(by: disposeBag)

        input.tapBack
            .subscribe(onNext: { [weak self] _ in
                self?.output.goToHome.accept(())
            }).disposed(by: disposeBag)

        configWorker.decodeSessionList { [weak self] result in
            switch result {
            case .success(let list): self?.output.sessionList.accept(list)
            case .failure: self?.output.hasError.accept(true)
            }
        }

        isRefreshing
            .subscribe(onNext: { [weak self] isRefreshing in
                guard isRefreshing == true else { return }
                self?.setupConfig()
                self?.checkLoginId()
            }).disposed(by: disposeBag)

        setupConfig()
        checkLoginId()
    }

    func setupConfig() {
        configWorker.decodeYappConfig { [weak self] result in
            switch result {
            case .success(let config):
                self?.output.yappConfig.onNext(config)
                self?.userDefaultsWorker.setGeneration(generation: config.generation)
                self?.userDefaultsWorker.setSessionCount(session: config.sessionCount)
            case .failure:
                self?.output.hasError.accept(true)
            }
        }
    }

    func checkLoginId() {
        if let kakaoTalkId = userDefaultsWorker.getKakaoTalkId(), kakaoTalkId.isEmpty == false {
            myId.accept(kakaoTalkId)
            getUserData()
        } else if let appleId = userDefaultsWorker.getAppleId(), appleId.isEmpty == false {
            myId.accept(appleId)
            getUserData()
        } else if let guestId = userDefaultsWorker.getGuestId(), guestId.isEmpty == false {
			isGuest.accept(true)
            myId.accept(guestId)
            getUserData()
        } else {
            output.goToLoginVC.accept(())
        }
    }

    func getUserData() {
        firebaseWorker.getMemberDocumentData(memberId: Int(myId.value) ?? 0) { result in
            switch result {
            case .success(let member):
                self.memberData.accept(member)
                self.userDefaultsWorker.setName(name: member.name)
                self.calculateScore()
            case .failure:
                self.output.hasError.accept(true)
            }
            self.isRefreshing.accept(false)
        }
    }

    func calculateScore() {
        output.totalScore.accept(0)
        output.attendanceScore.accept(0)
        output.absenceScore.accept(0)
        output.tardyScore.accept(0)
        guard let data = memberData.value else { return }
        guard let session = output.sessionList.value.todaySession() else { return }
        for idx in 0..<data.attendances.count {
            if data.attendances[idx].sessionId < session.sessionId, output.sessionList.value[idx].type == .needAttendance {
                let currentScore = output.totalScore.value
                output.totalScore.accept(currentScore + data.attendances[idx].type.point)
                if data.attendances[idx].type.text == "출석" || data.attendances[idx].type.text == "출석 인정" {
                    let attendanceScore = output.attendanceScore.value
                    output.attendanceScore.accept(attendanceScore + 1)
                } else if data.attendances[idx].type.text == "결석" {
                    let absenceScore = output.absenceScore.value
                    output.absenceScore.accept(absenceScore + 1)
                } else {
                    let tardyScore = output.tardyScore.value
                    output.tardyScore.accept(tardyScore + 1)
                }
            }
        }
		output.isReload.accept(true)
    }
}
