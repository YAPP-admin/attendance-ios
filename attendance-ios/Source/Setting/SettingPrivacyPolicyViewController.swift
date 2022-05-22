//
//  SettingPrivacyPolicyViewController.swift
//  attendance-ios
//
//  Created by 김보민 on 2022/04/28.
//

import Foundation
import RxCocoa
import RxSwift
import SnapKit
import UIKit
import WebKit

final class SettingPrivacyPolicyViewController: UIViewController {
    let navigationBarView = BaseNavigationBarView(title: "개인정보 처리방침")
    var wkWebView: WKWebView = {
        let web = WKWebView()
        web.backgroundColor = .white
        web.isOpaque = false
        web.allowsLinkPreview = false
        web.allowsBackForwardNavigationGestures = true
        return web
    }()

    private let viewModel = SettingViewModel()
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        if let url = URL(string: "https://yapprecruit.notion.site/8b561d1b0fa449bba4db395f53a559f3") {
            let request = URLRequest(url: url)
            wkWebView.load(request)
        }

        addSubViews()
        bind()
    }

    func addSubViews() {
        view.addSubview(navigationBarView)
        navigationBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        view.addSubview(wkWebView)
        wkWebView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    func bind() {
		wkWebView.navigationDelegate = self
        navigationBarView.backButton.rx.tap
            .bind(to: viewModel.input.tapBack)
            .disposed(by: disposeBag)

        viewModel.output.goToHome
            .observe(on: MainScheduler.instance)
            .bind(onNext: showSettingVC)
            .disposed(by: disposeBag)

		viewModel.output.isLoading
			.observe(on: MainScheduler.instance)
			.subscribe(onNext: { [weak self] isLoading in
				isLoading ? self?.showLoadingView() : self?.hideLoadingView()
			})
			.disposed(by: disposeBag)
    }

    func showSettingVC() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SettingPrivacyPolicyViewController: WKNavigationDelegate {
	func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
		viewModel.output.isLoading.onNext(true)
	}

	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		viewModel.output.isLoading.onNext(false)
	}

	func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
		showSettingVC()
	}
}
