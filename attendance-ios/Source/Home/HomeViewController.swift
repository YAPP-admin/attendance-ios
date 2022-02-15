//
//  HomeViewController.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/01/31.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import AVFoundation

final class HomeViewController: UIViewController {

    private let guideLabel: UILabel = {
        let label = UILabel()
        label.text = "2시 5분까지 출석체크를 완료해주세요!\n이후 출석은 지각으로 처리돼요"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.clipsToBounds = true
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
        view.backgroundColor = .white

        bindViewModel()
        configureNavigationBar()
        configureCaptureSession()
        configureMaskView()
        configureGuideLabel()
        addSubViews()
    }

}

extension HomeViewController: AVCaptureMetadataOutputObjectsDelegate {

    private func configureMaskView() {
        let maskLayer = CAShapeLayer()
        let path = UIBezierPath(rect: view.bounds)

        path.append(UIBezierPath(rect: CGRect(x: (view.bounds.width-240)/2, y: 132, width: 240, height: 240)))

        maskLayer.path = path.cgPath
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd

        dimmedView.layer.mask = maskLayer
    }

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
        let detailVC = DetailViewController()
        navigationController?.pushViewController(detailVC, animated: true)
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
        attributedString.addAttributes([.font: UIFont.systemFont(ofSize: 16, weight: .bold), .foregroundColor: UIColor.yappYellow], range: timeRange)
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16, weight: .bold), range: tardyRange)

        guideLabel.attributedText = attributedString
        guideLabel.textAlignment = .center
    }

    func addSubViews() {
        view.addSubview(dimmedView)
        view.addSubview(guideLabel)
        view.addSubview(homebottomView)

        dimmedView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
        guideLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(60)
            $0.centerX.equalToSuperview()
        }
        homebottomView.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.height.equalTo(250)
        }
    }

    func configureNavigationBar() {
        navigationItem.hidesBackButton = true
        navigationItem.backButtonTitle = ""
    }

}
