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
    private let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
	private let settingButton: UIButton = {
		let button = UIButton()
		button.backgroundColor = .clear
		button.setImage(UIImage(named: "setting"), for: .normal)
		button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		return button
	}()
    private lazy var tabView: HomeBottomTabView = {
        let view = HomeBottomTabView()
        return view
    }()
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray_400
        return view
    }()
    private let illustView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.image = UIImage(named: "illust_member_home_disabled")
        return view
    }()
    private let infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    private let infoStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 8
        return view
    }()
    private let checkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "info_check_disabled"), for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 출석 전이에요"
        label.font(.Body2)
        label.textColor = .gray_600
        return label
    }()
    private let contentsView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()

    private let viewModel = HomeViewModel()
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        navigationController?.isNavigationBarHidden = true

        addSubViews()
        bind()

        bgView.setGradient(color1: .white, color2: .gray_400)
    }

    func addSubViews() {
        view.addSubview(topView)
        topView.addSubview(settingButton)
        view.addSubview(tabView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        topView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        settingButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-14)
            $0.width.height.equalTo(44)
        }
        tabView.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.height.equalTo(100)
        }

        contentView.addSubview(bgView)
        bgView.addSubview(illustView)
        contentView.addSubview(infoView)
        infoView.addSubview(infoStackView)
        infoStackView.addArrangedSubview(checkButton)
        infoStackView.addArrangedSubview(infoLabel)
        contentView.addSubview(contentsView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(tabView.snp.top)
        }
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.greaterThanOrEqualToSuperview()
        }
        bgView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.equalTo(330)
            $0.leading.trailing.equalToSuperview()
        }
        illustView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(86)
        }
        infoView.snp.makeConstraints {
            $0.top.equalTo(illustView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(60)
        }
        infoStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        checkButton.snp.makeConstraints {
            $0.width.height.equalTo(20
            )
        }
        contentsView.snp.makeConstraints {
            $0.top.equalTo(infoView.snp.bottom).offset(20)
            $0.height.equalTo(369)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
    }

    func bind() {
        tabView.qrButton.rx.tap
            .bind(to: viewModel.input.tapQR)
            .disposed(by: disposeBag)

        viewModel.output.goToQR
            .observe(on: MainScheduler.instance)
            .bind(onNext: showQRVC)
            .disposed(by: disposeBag)
    }

    func showQRVC() {
        let vc = QRViewController()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
}


extension UIView{
    func setGradient(color1:UIColor,color2:UIColor){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor,color2.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = bounds
        layer.addSublayer(gradient)
    }
}
