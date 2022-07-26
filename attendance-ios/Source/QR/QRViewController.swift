//
//  QRViewController.swift
//  attendance-ios
//
//  Created by 김보민 on 2022/03/02.
//

import AVFoundation
import RxCocoa
import RxSwift
import SnapKit
import UIKit

protocol QRLoginDelegate: AnyObject {
    func loggedIn()
}

final class QRViewController: UIViewController {
	private let guideLabel: UILabel = {
		let label = UILabel()
		label.textColor = .white
		label.numberOfLines = 0
		label.textAlignment = .center
		label.style(.Body1)
		return label
	}()

	private let closeButton: UIButton = {
		let button = UIButton()
		button.backgroundColor = .clear
		button.setImage(UIImage(named: "close"), for: .normal)
		button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		return button
	}()

	private let frameView: UIImageView = {
		let view = UIImageView()
		view.backgroundColor = .clear
		view.image = UIImage(named: "qr_frame")
		return view
	}()

	private let checkView: UIImageView = {
		let view = UIImageView()
		view.backgroundColor = .clear
		view.image = UIImage(named: "qr_check_enabled")
		view.isHidden = true
		return view
	}()

	private let captureSession = AVCaptureSession()
	var updateHomeData : ((Bool) -> Void)?

	var viewModel = QRViewModel()
	private var disposeBag = DisposeBag()
    internal weak var delegate: QRLoginDelegate?

    override func viewWillAppear(_ animated: Bool) {
        viewModel.getConfigTime()
    }

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .clear

		configureCaptureSession()
		setup()
		bind()
	}

	func setup() {
		viewModel.setupQrPassword()
		view.addSubview(closeButton)
		view.addSubview(guideLabel)
		view.addSubview(frameView)
		frameView.addSubview(checkView)

		closeButton.snp.makeConstraints {
			$0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
			$0.trailing.equalToSuperview().offset(-14)
			$0.width.equalTo(44)
			$0.height.equalTo(44)
		}
		frameView.snp.makeConstraints {
			$0.width.height.equalTo(240)
			$0.center.equalToSuperview()
		}
		guideLabel.snp.makeConstraints {
			$0.bottom.equalTo(frameView.snp.top).offset(-40)
			$0.centerX.equalToSuperview()
		}
		checkView.snp.makeConstraints {
			$0.center.equalToSuperview()
			$0.width.height.equalTo(76)
		}
	}

	func bind() {
		closeButton.rx.tap
			.bind(to: viewModel.input.tapClose)
			.disposed(by: disposeBag)

		viewModel.output.goToHome
			.observe(on: MainScheduler.instance)
			.bind(onNext: showHomeVC)
			.disposed(by: disposeBag)

        viewModel.output.showToastFail
            .observe(on: MainScheduler.instance)
            .bind(onNext: showToastFail)
            .disposed(by: disposeBag)

        viewModel.output.time
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] time in
                self?.guideLabel.text = time
            }).disposed(by: disposeBag)
	}

	func showHomeVC() {
		dismiss(animated: true, completion: nil)
	}

    func showToastFail() {
        showToast(message: "오류가 발생했어요.\n홈으로 돌아가서 다시 시도해 주세요.")
    }

	func showCheck() {
		viewModel.updateAttendances()
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
			self.showToast(message: "출석 완료")
            self.checkView.isHidden = false
			if let updateHomeData = self.updateHomeData {
				updateHomeData(true)
			}
		}, completion: { _ in
            UIView.animate(withDuration: 3.0, delay: 2.0, options: .curveEaseOut, animations: {
				self.showHomeVC()
                self.delegate?.loggedIn()
            }, completion: nil)
        })
	}
}

extension QRViewController: AVCaptureMetadataOutputObjectsDelegate {
	private func configureCaptureSession() {
		guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }

		do {
			let input = try AVCaptureDeviceInput(device: device)
			let output = AVCaptureMetadataOutput()

			captureSession.addInput(input)
			captureSession.addOutput(output)

			output.setMetadataObjectsDelegate(self, queue: .main)
			output.metadataObjectTypes = [.qr]

			let rectOfInterest = CGRect(x: (UIScreen.main.bounds.width - 200) / 2, y: (UIScreen.main.bounds.height - 200) / 2, width: 200, height: 200)
			let rectConverted = setVideoLayer(rectOfInterest: rectOfInterest)
			output.rectOfInterest = rectConverted

			captureSession.startRunning()
		} catch {}
	}

	private func setVideoLayer(rectOfInterest: CGRect) -> CGRect {
		let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
		previewLayer.frame = view.layer.bounds
		previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
		view.layer.addSublayer(previewLayer)

		return previewLayer.metadataOutputRectConverted(fromLayerRect: rectOfInterest)
	}

	func metadataOutput(_ captureOutput: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
		guard let metadataObject = metadataObjects.first, let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject, let stringValue = readableObject.stringValue else { return }
		if let res = try? JSONSerialization.jsonObject(with: Data(stringValue.utf8), options: []) as? [String: Any] {
			let qrPassword = self.viewModel.output.qrPassword.value
			guard let id = res["session_id"] as? Int,
				  let password = res["password"] as? String,
				  let session = self.viewModel.output.sessionList.value.todaySession() else { return }
			if id == session.sessionId, password == qrPassword {
				self.captureSession.stopRunning()
				showCheck()
			}
		} else if viewModel.output.isPass.value == true {
			self.captureSession.stopRunning()
			showCheck()
		}
	}
}
