//
//  EasterEggView.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/05/17.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class EasterEggView: UIView {

    enum Constants {
        static let padding: CGFloat = 24
        static let spacing: CGFloat = 20
        static let labelStackViewHeight: CGFloat = 56
        static let cornerRadius: CGFloat = 10

        static let textFieldHeight: CGFloat = 47
        static let textFieldFontSize: CGFloat = 16
        static let wrongMessageLabelHeight: CGFloat = 20
        static let keyboardPadding: CGFloat = 40
        static let buttonHeight: CGFloat = 47
        static let buttonSpacing: CGFloat = 12

        static let containerViewHeight: CGFloat = Constants.labelStackViewHeight+textFieldHeight+Constants.buttonHeight+Constants.padding+Constants.spacing*3
        static let containerViewHeightWithMessage: CGFloat = Constants.labelStackViewHeight+textFieldHeight+Constants.wrongMessageLabelHeight+Constants.buttonHeight+Constants.padding+Constants.spacing*4
    }

    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .background
        view.layer.cornerRadius = Constants.cornerRadius
        return view
    }()

    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        return stackView
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .gray_1200
        label.font = .Pretendard(type: .bold, size: 18)
        label.text = "암호를 대라!"
        return label
    }()

    private let subLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray_800
        label.font = .Pretendard(type: .medium, size: 16)
        label.text = "코드 넘버를 입력해주세요"
        return label
    }()

    let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "****"
        textField.backgroundColor = .gray_200
        textField.layer.cornerRadius = Constants.cornerRadius
        textField.font = .Pretendard(type: .bold, size: Constants.textFieldFontSize)
        textField.textColor = .gray_800
        textField.tintColor = .yapp_orange
        textField.textAlignment = .center
        textField.isSecureTextEntry = true
        return textField
    }()

    private let wrongMessageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .etc_red
        label.font = .Pretendard(type: .semiBold, size: 16)
        label.text = "틀린 비밀번호입니다"
        label.isHidden = true
        return label
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Constants.buttonSpacing
        stackView.distribution = .fillEqually
        return stackView
    }()

    private let leftButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray_200
        button.setTitleColor(.gray_800, for: .normal)
        button.titleLabel?.font = .Pretendard(type: .bold, size: 16)
        button.layer.cornerRadius = Constants.cornerRadius
        button.setTitle("취소", for: .normal)
        return button
    }()

    let rightButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .yapp_orange
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .Pretendard(type: .bold, size: 16)
        button.layer.cornerRadius = Constants.cornerRadius
        button.setTitle("확인", for: .normal)
        return button
    }()

    private var disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        bindSubViews()
        configureUI()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - TextField
extension EasterEggView {

    func endEditingTextField() {
        clearTextField()
        hideKeyboard()
    }

    func clearTextField() {
        textField.text = ""
    }

    func hideKeyboard() {
        textField.endEditing(true)
    }

}

// MARK: - Keyboard
extension EasterEggView {

    func animateWhenKeyboardShow(with keyboardHeight: CGFloat) {
        let viewHeight = bounds.height
        let containerHeight = containerView.bounds.height
        let padding = Constants.keyboardPadding
        let offset = viewHeight/2-(keyboardHeight+containerHeight/2+padding)
        guard offset < 0 else { return }

        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.containerView.snp.updateConstraints {
                $0.centerY.equalToSuperview().offset(offset)
            }
            self?.containerView.superview?.layoutIfNeeded()
        })
    }

    func animateWhenKeyboardHide() {
        containerView.snp.updateConstraints {
            $0.centerY.equalToSuperview().offset(0)
        }
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.containerView.snp.updateConstraints {
                $0.centerY.equalToSuperview().offset(0)
            }
            self?.containerView.superview?.layoutIfNeeded()
        })
    }

}

// MARK: - Error Message
extension EasterEggView {

    func showWrongMessage() {
        let height = Constants.containerViewHeightWithMessage
        containerView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
        wrongMessageLabel.isHidden = false
    }

    func hideWrongMessage() {
        let height = Constants.containerViewHeight
        containerView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
        wrongMessageLabel.isHidden = true
    }

}

// MARK: - UI
private extension EasterEggView {

    func bindSubViews() {
        leftButton.rx.controlEvent([.touchUpInside])
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.endEditingTextField()
                self?.hideWrongMessage()
                self?.isHidden = true
            }).disposed(by: disposeBag)
    }

    func configureUI() {
        backgroundColor = .black.withAlphaComponent(0.4)
    }

    func configureLayout() {
        addSubview(containerView)
        containerView.addSubviews([labelStackView, textField, wrongMessageLabel, stackView])
        stackView.addArrangedSubviews([leftButton, rightButton])
        labelStackView.addArrangedSubviews([label, subLabel])

        containerView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(Constants.padding)
            $0.center.equalToSuperview()
            $0.height.equalTo(Constants.containerViewHeight)
        }
        labelStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Constants.padding)
            $0.left.right.equalToSuperview().inset(Constants.padding)
            $0.height.equalTo(Constants.labelStackViewHeight)
        }
        textField.snp.makeConstraints {
            $0.top.equalTo(labelStackView.snp.bottom).offset(Constants.spacing)
            $0.left.right.equalToSuperview().inset(Constants.padding)
            $0.height.equalTo(Constants.textFieldHeight)
        }
        wrongMessageLabel.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(Constants.spacing)
            $0.left.right.equalToSuperview().inset(Constants.padding)
            $0.height.equalTo(Constants.wrongMessageLabelHeight)
        }
        stackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(Constants.spacing)
            $0.left.right.bottom.equalToSuperview().inset(Constants.padding)
            $0.height.equalTo(Constants.buttonHeight)
        }
    }

}
