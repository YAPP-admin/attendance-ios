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
        let tapHelp = PublishRelay<Void>()
        let tapBack = PublishRelay<Void>()
    }

    struct Output {
        let sessionList = BehaviorRelay<[Session]>(value: [])
        let goToQR = PublishRelay<Void>()
        let goToSetting = PublishRelay<Void>()
        let goToHelp = PublishRelay<Void>()
        let goToHome = PublishRelay<Void>()
        let goToLoginVC = PublishRelay<Void>()
        let yappConfig = BehaviorSubject<YappConfig?>(value: nil)
        
        let kakaoAccessToken = PublishSubject<String>()
        let kakaoTalkId = BehaviorSubject<String>(value: "")
        let appleId = BehaviorSubject<String>(value: "")
    }

    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()
    let configWorker = ConfigWorker()
    let homeType = BehaviorRelay<HomeType>(value: .todaySession)
    let myId = BehaviorRelay<String>(value: "")
    
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

        input.tapHelp
            .subscribe(onNext: { [weak self] _ in
                self?.output.goToHelp.accept(())
            }).disposed(by: disposeBag)

        input.tapBack
            .subscribe(onNext: { [weak self] _ in
                self?.output.goToHome.accept(())
            }).disposed(by: disposeBag)

        configWorker.decodeSessionList { [weak self] result in
            switch result {
            case .success(let list): self?.output.sessionList.accept(list)
            case .failure: ()
            }
        }

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
            case .failure: ()
            }
        }
    }

    func checkLoginId() {
        if let kakaoTalkId = userDefaultsWorker.kakaoTalkId(), kakaoTalkId.isEmpty == false {
            myId.accept(kakaoTalkId)
        } else if let appleId = userDefaultsWorker.appleId(), appleId.isEmpty == false {
            myId.accept(appleId)
        } else {
            output.goToLoginVC.accept(())
            return
        }
        getUserData()
    }

    func getUserData() {
        firebaseWorker.getMemberDocumentData(memberId: Int(myId.value) ?? 0) { member in
            print(member)
        }
    }
}
