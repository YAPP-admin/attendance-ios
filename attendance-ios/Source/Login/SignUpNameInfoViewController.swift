//
//  SignUpNameInfoViewController.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/02/23.
//

import UIKit

final class SignUpNameInfoViewController: UIViewController {

    enum Constants {
        static let padding: CGFloat = 24
        static let textFieldHeight: CGFloat = 60
        static let fontSize: CGFloat = 16
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "만나서 반가워요!\n이름을 알려주세요"
        label.font = .systemFont(ofSize: 24, weight: .heavy)
        label.font = .Pretendard(type: .Bold, size: 24)
        label.textColor = .gray_1200
        label.numberOfLines = 0
        label.setLineSpacing(4)
        return label
    }()

    private let textField: UITextField = {
        let textField = UITextField()
        textField.font = .Pretendard(type: .Bold, size: Constants.fontSize)
        textField.textColor = .gray_800
        textField.attributedPlaceholder = NSAttributedString(string: "ex. 야뿌", attributes: [.foregroundColor: UIColor.gray_400, .font: UIFont.Pretendard(type: .Bold, size: Constants.fontSize)])
        textField.backgroundColor = .gray_200
        textField.layer.cornerRadius = Constants.textFieldHeight/2
        textField.addLeftPadding(20)
        return textField
    }()

    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = .Pretendard(type: .Bold, size: 18)
        button.backgroundColor = .gray_400
        button.layer.cornerRadius = 10
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
    }

}

private extension SignUpNameInfoViewController {

    func configureUI() {
        view.backgroundColor = .white
    }

    func configureLayout() {
        view.addSubview(titleLabel)
        view.addSubview(textField)
        view.addSubview(nextButton)

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            $0.left.equalToSuperview().offset(Constants.padding)
        }
        textField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(28)
            $0.left.right.equalToSuperview().inset(Constants.padding)
            $0.height.equalTo(Constants.textFieldHeight)
        }
        nextButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(Constants.padding)
            $0.bottom.equalToSuperview().inset(40)
            $0.height.equalTo(60)
        }
    }

}
