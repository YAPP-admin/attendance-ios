//
//  SignUpNameInfoViewController.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/02/23.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class SignUpNameInfoViewController: UIViewController {

    enum Constants {
        static let padding: CGFloat = 24
        static let textFieldHeight: CGFloat = 60
        static let textFieldFontSize: CGFloat = 16
        static let buttonHeight: CGFloat = 60
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "이름을 작성해주세요"
        label.font = .Pretendard(type: .Bold, size: 24)
        label.textColor = .gray_1200
        label.numberOfLines = 0
        return label
    }()

    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "실명을 작성해야 출석을 확인할 수 있어요"
        label.font = .Pretendard(type: .Medium, size: 16)
        label.textColor = .gray_800
        label.numberOfLines = 0
        return label
    }()

    private let textField: UITextField = {
        let textField = UITextField()
        textField.font = .Pretendard(type: .Bold, size: Constants.textFieldFontSize)
        textField.textColor = .gray_800
        textField.attributedPlaceholder = NSAttributedString(string: "ex. 야뿌", attributes: [.foregroundColor: UIColor.gray_400, .font: UIFont.Pretendard(type: .Bold, size: Constants.textFieldFontSize)])
        textField.backgroundColor = .gray_200
        textField.layer.cornerRadius = Constants.textFieldHeight/2
        textField.addLeftPadding(20)
        textField.tintColor = .yapp_orange
        return textField
    }()

    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = .Pretendard(type: .Bold, size: 18)
        button.backgroundColor = .gray_400
        button.layer.cornerRadius = 10
        button.isEnabled = false
        return button
    }()

    private lazy var accessoryView: UIView = {
        let view = UIView(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: Constants.buttonHeight))
        return view
    }()

    private let keyboardNextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = .Pretendard(type: .Bold, size: 18)
        button.backgroundColor = .gray_400
        button.isEnabled = false
        return button
    }()

    private var textFieldText: String = ""
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindTextField()
        bindButton()
        setupDelegate()
        setupTextField()
        configureUI()
        configureLayout()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}

extension SignUpNameInfoViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool { textField.resignFirstResponder()
        return true
    }

}

private extension SignUpNameInfoViewController {

    func bindTextField() {
        textField.rx.text
            .subscribe(onNext: { [weak self] text in
                guard let self = self, let text = text else { return }
                self.textFieldText = text
                self.configureButtons(isTextFieldValid: (text.count > 1))
            }).disposed(by: disposeBag)
    }

    func bindButton() {
        nextButton.rx.controlEvent([.touchUpInside])
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.goToSignUpTeamVC()
            }).disposed(by: disposeBag)

        keyboardNextButton.rx.controlEvent([.touchUpInside])
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.goToSignUpTeamVC()
            }).disposed(by: disposeBag)
    }

    func goToSignUpTeamVC() {
        let signUpTeamInfoVC = SignUpTeamInfoViewController()
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .gray_800
        navigationController?.pushViewController(signUpTeamInfoVC, animated: true)
    }

    func setupDelegate() {
        textField.delegate = self
    }

    func setupTextField() {
        textField.inputAccessoryView = accessoryView
    }

    func configureButtons(isTextFieldValid: Bool) {
        nextButton.isEnabled = isTextFieldValid
        nextButton.backgroundColor = isTextFieldValid ? UIColor.yapp_orange : UIColor.gray_400
        keyboardNextButton.isEnabled = isTextFieldValid
        keyboardNextButton.backgroundColor = isTextFieldValid ? UIColor.yapp_orange : UIColor.gray_400
    }

    func configureUI() {
        view.backgroundColor = .white
    }

    func configureLayout() {
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(textField)
        view.addSubview(nextButton)

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            $0.left.right.equalToSuperview().inset(Constants.padding)
        }
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().offset(Constants.padding)
        }
        textField.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(28)
            $0.left.right.equalToSuperview().inset(Constants.padding)
            $0.height.equalTo(Constants.textFieldHeight)
        }
        nextButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(Constants.padding)
            $0.bottom.equalToSuperview().inset(40)
            $0.height.equalTo(Constants.buttonHeight)
        }

        accessoryView.addSubview(keyboardNextButton)

        keyboardNextButton.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
    }

}
