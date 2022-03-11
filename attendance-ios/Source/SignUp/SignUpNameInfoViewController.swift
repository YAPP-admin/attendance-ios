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

    private var disposeBag = DisposeBag()
    private let viewModel = SignUpViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        bindTextField()
        bindButton()
        setupDelegate()
        setupTextField()
        configureUI()
        configureLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
    }

}

// MARK: - Bind
private extension SignUpNameInfoViewController {

    func bindViewModel() {
        viewModel.output.isNameTextFieldValid
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isValid in
                isValid ? self?.activateButtons() : self?.deactivateButtons()
            })
            .disposed(by: disposeBag)
    }

    func bindTextField() {
        textField.rx.text
            .subscribe(onNext: { [weak self] text in
                guard let text = text else { return }
                self?.viewModel.input.name.onNext(text)
            }).disposed(by: disposeBag)
    }

    func bindButton() {
        nextButton.rx.controlEvent([.touchUpInside])
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.goToSignUpTeamVC()
            }).disposed(by: disposeBag)

        keyboardNextButton.rx.controlEvent([.touchUpInside])
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.goToSignUpTeamVC()
            }).disposed(by: disposeBag)
    }

}

// MARK: - TextField
extension SignUpNameInfoViewController: UITextFieldDelegate {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool { textField.resignFirstResponder()
        return true
    }

}

// MARK: - etc
private extension SignUpNameInfoViewController {

    func goToSignUpTeamVC() {
        let signUpTeamInfoVC = SignUpTeamInfoViewController(viewModel: viewModel)
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

    func activateButtons() {
        nextButton.isEnabled = true
        keyboardNextButton.isEnabled = true
        nextButton.backgroundColor = UIColor.yapp_orange
        keyboardNextButton.backgroundColor = UIColor.yapp_orange
    }

    func deactivateButtons() {
        nextButton.isEnabled = false
        keyboardNextButton.isEnabled = false
        nextButton.backgroundColor = UIColor.gray_400
        keyboardNextButton.backgroundColor = UIColor.gray_400
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
