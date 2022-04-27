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
    }

    struct Output {
        let sessionList = BehaviorSubject<[Session]>(value: [])
        var goToQR = PublishRelay<Void>()
        var goToSetting = PublishRelay<Void>()
    }

    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()
    let configWorker = ConfigWorker()
    var homeType = BehaviorRelay<HomeType>(value: .todaySession)

    var list = [AttendanceType.attendance, AttendanceType.attendanceMarked, AttendanceType.absence, AttendanceType.tardy]

    init() {
        input.tapQR
            .subscribe(onNext: { [weak self] _ in
                self?.output.goToQR.accept(())
            }).disposed(by: disposeBag)

        input.tapSetting
            .subscribe(onNext: { [weak self] _ in
                self?.output.goToSetting.accept(())
            }).disposed(by: disposeBag)

        configWorker.decodeSessionList { [weak self] result in
            switch result {
            case .success(let list): self?.output.sessionList.onNext(list)
            case .failure: ()
            }
        }
    }
}
