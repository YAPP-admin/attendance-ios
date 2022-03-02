//
//  HomeViewController.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/01/31.
//

import AVFoundation
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class HomeViewController: UIViewController {

    private let guideLabel: UILabel = {
        let label = UILabelWithRound(frame: .zero, color: UIColor.clear.cgColor, width: 0, inset: UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24))
        label.text = "2시 5분까지 출석체크를 완료해주세요!"
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
		label.font(.Body2)
		label.backgroundColor = UIColor(red: 0.173, green: 0.185, blue: 0.208, alpha: 0.8)
        return label
    }()

	private let settingButton: UIButton = {
		let button = UIButton()
		button.backgroundColor = .clear
		button.setImage(UIImage(named: "setting"), for: .normal)
		button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
		return button
	}()

	private let frameView: UIImageView = {
		let view = UIImageView()
		view.backgroundColor = .clear
		view.image = UIImage(named: "qr_frame")
		return view
	}()

    private lazy var homebottomView: HomeBottomView = {
        let view = HomeBottomView()
        view.delegate = self
        return view
    }()

    private let captureSession = AVCaptureSession()

    private let viewModel = BaseViewModel()
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
		navigationController?.isNavigationBarHidden = true

        bindViewModel()
//        configureNavigationBar()
        configureCaptureSession()
//        configureMaskView()
//        configureGuideLabel()
        addSubViews()
    }

}

extension HomeViewController: AVCaptureMetadataOutputObjectsDelegate {

//    private func configureMaskView() {
//        let maskLayer = CAShapeLayer()
//        let path = UIBezierPath(rect: view.bounds)
//
//        path.append(UIBezierPath(rect: CGRect(x: (view.bounds.width-240)/2, y: 132, width: 240, height: 240)))
//        maskLayer.path = path.cgPath
//        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
//		self.view.layer.mask = maskLayer
//    }

    private func configureCaptureSession() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }

        do {
            let input = try AVCaptureDeviceInput(device: device)
            let output = AVCaptureMetadataOutput()

            captureSession.addInput(input)
            captureSession.addOutput(output)

            output.setMetadataObjectsDelegate(self, queue: .main)
            output.metadataObjectTypes = [.qr]

            configurePreviewLayer()
            captureSession.startRunning()
        } catch {}
    }

    private func configurePreviewLayer() {
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.addSublayer(previewLayer)
    }

    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let metadataObject = metadataObjects.first, let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject, let stringValue = readableObject.stringValue else { return }

        // MARK: - 출석인증
        print("stringValue: \(stringValue)")
//            self.captureSession.stopRunning()
    }

}

extension HomeViewController: HomeBottomViewDelegate {

    func showDetailVC() {
//        let detailVC = DetailViewController()
//        navigationController?.pushViewController(detailVC, animated: true)
		let qrVC = QRViewController()
		qrVC.modalPresentationStyle = .fullScreen
		qrVC.modalTransitionStyle = .coverVertical
		present(qrVC, animated: true, completion: nil)
    }
}

private extension HomeViewController {

    func bindViewModel() {
		
    }

    func configureGuideLabel() {
        guard let fullText = guideLabel.text else { return }

        let attributedString = NSMutableAttributedString(string: fullText)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6

        let timeRange = (fullText as NSString).range(of: "2시 5분")
        let tardyRange = (fullText as NSString).range(of: "지각")

        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
		attributedString.addAttributes([.font: UIFont.systemFont(ofSize: 16, weight: .bold), .foregroundColor: UIColor.yapp_yellow], range: timeRange)
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16, weight: .bold), range: tardyRange)

        guideLabel.attributedText = attributedString
        guideLabel.textAlignment = .center
    }

    func addSubViews() {
		view.addSubview(settingButton)
        view.addSubview(guideLabel)
        view.addSubview(homebottomView)
		view.addSubview(frameView)

		settingButton.snp.makeConstraints {
			$0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
			$0.trailing.equalToSuperview()
			$0.width.equalTo(68)
			$0.height.equalTo(44)
		}
        guideLabel.snp.makeConstraints {
			$0.top.equalTo(settingButton.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        homebottomView.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.height.equalTo(250)
        }
		frameView.snp.makeConstraints {
			$0.top.equalTo(guideLabel.snp.bottom).offset(20)
			$0.leading.equalToSuperview().offset(68)
			$0.trailing.equalToSuperview().offset(-68)
		}
    }

    func configureNavigationBar() {
        navigationItem.hidesBackButton = true
        navigationItem.backButtonTitle = ""
    }

}
