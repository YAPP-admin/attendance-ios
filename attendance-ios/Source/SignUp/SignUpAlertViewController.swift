//
//  SignUpAlertViewController.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/03/08.
//

import UIKit

final class SignUpAlertViewController: UIViewController {

    enum Constants {
        static let margin: CGFloat = 32
        static let padding: CGFloat = 24
        static let containerViewHeight: CGFloat = 174
        static let cornerRadius: CGFloat = 10
        static let labelSpacing: CGFloat = 6

        static let buttonHeight: CGFloat = 47
        static let buttonSpacing: CGFloat = 12
    }

    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        view.layer.cornerRadius = Constants.cornerRadius
        return view
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.text = "입력을 취소할까요?"
        label.textColor = .gray_1200
        label.font = .Pretendard(type: .Bold, size: 18)
        return label
    }()

    private let subLabel: UILabel = {
        let label = UILabel()
        label.text = "언제든 다시 돌아올 수 있어요"
        label.textColor = .gray_800
        label.font = .Pretendard(type: .Medium, size: 16)
        return label
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Constants.buttonSpacing
        stackView.distribution = .fillEqually
        return stackView
    }()

    private let noButton: UIButton = {
        let button = UIButton()
        button.setTitle("아니요", for: .normal)
        button.backgroundColor = .gray_200
        button.setTitleColor(.gray_800, for: .normal)
        button.titleLabel?.font = .Pretendard(type: .Medium, size: 16)
        button.layer.cornerRadius = Constants.cornerRadius
        return button
    }()

    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소합니다", for: .normal)
        button.backgroundColor = .yapp_orange
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .Pretendard(type: .Medium, size: 16)
        button.layer.cornerRadius = Constants.cornerRadius
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
    }

}

private extension SignUpAlertViewController {

    func configureUI() {
        view.backgroundColor = .black.withAlphaComponent(0.2)
    }

    func configureLayout() {
        view.addSubview(containerView)
        containerView.addSubview(label)
        containerView.addSubview(subLabel)
        containerView.addSubview(stackView)

        stackView.addArrangedSubview(noButton)
        stackView.addArrangedSubview(cancelButton)

        containerView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(Constants.margin)
            $0.center.equalToSuperview()
            $0.height.equalTo(Constants.containerViewHeight)
        }
        label.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(Constants.padding)
        }
        subLabel.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(Constants.labelSpacing)
            $0.left.right.equalToSuperview().inset(Constants.padding)
        }
        stackView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview().inset(Constants.padding)
            $0.height.equalTo(Constants.buttonHeight)
        }
    }

}
