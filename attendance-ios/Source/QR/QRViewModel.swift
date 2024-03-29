//
//  QRViewModel.swift
//  attendance-ios
//
//  Created by 김보민 on 2022/03/02.
//

import RxCocoa
import RxSwift
import UIKit

final class QRViewModel: ViewModel {
	struct Input {
		let tapClose = PublishRelay<Void>()
	}

	struct Output {
		var goToHome = PublishRelay<Void>()
        let time = BehaviorSubject<String>(value: "")
        let showToastFail = PublishRelay<Void>()
		let sessionList = BehaviorRelay<[Session]>(value: [])
		let memberData = BehaviorSubject<Member?>(value: nil)
        let currentType = BehaviorRelay<Status>(value: .absent)
		let qrPassword = BehaviorRelay<String>(value: "")
		let isPass = BehaviorRelay<Bool>(value: false)
	}

	let input = Input()
	let output = Output()
	let disposeBag = DisposeBag()
    private let configWorker = ConfigWorker.shared
	private let firebaseWorker = FirebaseWorker()

	init() {
		input.tapClose
			.subscribe(onNext: { [weak self] _ in
				self?.output.goToHome.accept(())
			}).disposed(by: disposeBag)

		configWorker.decodeSessionList { [weak self] result in
			switch result {
			case .success(let list): self?.output.sessionList.accept(list)
			case .failure: ()
			}
		}
	}

    func getConfigTime() {
        configWorker.decodeMaginotlineTime { [weak self] result in
            switch result {
            case .success(let time):
                if time.isEmpty == false {
                    self?.output.time.onNext(time + "까지 출석해주세요.\n30분까지는 지각, 그 이후는 결석으로 처리돼요.")
                } else {
                    self?.output.time.onNext("정보를 불러오지 못했어요.")
                }
            case .failure: self?.output.time.onNext("정보를 불러오지 못했어요.")
            }
        }
    }

	func updateAttendances() {
		guard let member = try? output.memberData.value(), let session = output.sessionList.value.todaySession() else { return }
		var attendances = member.attendances
        attendances[session.sessionId].status = output.currentType.value
		firebaseWorker.updateMemberAttendances(memberId: member.id, attendances: attendances)
	}

	func setupQrPassword() {
		configWorker.decodeQrPassword { [weak self] result in
			switch result {
			case .success(let config):
				self?.output.qrPassword.accept(config)
			case .failure: ()
			}
		}
	}

}
