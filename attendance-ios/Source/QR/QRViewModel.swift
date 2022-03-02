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
	}

	let input = Input()
	let output = Output()
	let disposeBag = DisposeBag()

	init() {
		input.tapClose
			.subscribe(onNext: { [weak self] _ in
				self?.output.goToHome.accept(())
			}).disposed(by: disposeBag)
	}
}
