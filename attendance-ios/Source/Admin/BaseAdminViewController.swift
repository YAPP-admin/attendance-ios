//
//  BaseAdminViewController.swift
//  attendance-ios
//
//  Created by 김나희 on 5/17/23.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

class BaseAdminViewController: UIViewController {
    private let viewModel: AdminViewModel
    private var disposeBag = DisposeBag()
    
    // MARK: UI Components
    let navigationBarView: BaseNavigationBarView = {
        let barView = BaseNavigationBarView(title: "")
        barView.titleLabel.textAlignment = .center
        barView.navigationBarView.backgroundColor = .clear
        return barView
    }()
    
    let segmentContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var segmentedControl: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["팀별", "직군별"])
        seg.addTarget(self, action: #selector(segmentControlIndexChanged), for: .valueChanged)
        seg.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        seg.selectedSegmentIndex = 0
        return seg
    }()
    
    lazy var segmentUnderlineIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.yapp_orange
        return view
    }()

    // MARK: Init
    init(viewModel: AdminViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    init?(coder: NSCoder, viewModel: AdminViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindSubViews()
        
        setupSegmentControl()
        
        configureUI()
        configureLayout()
        
        setRightSwipeRecognizer()
    }
    
    override func dismissWhenSwipeRight() {
        viewModel.input.selectedTeamIndexListInManagement.onNext([])
        navigationController?.popViewController(animated: true)
    }
    
    func bindSubViews() {
        navigationBarView.backButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.viewModel.input.selectedTeamIndexListInManagement.onNext([])
                    self?.navigationController?.popViewController(animated: true)
                }
            }).disposed(by: disposeBag)
    }
    
    @objc func segmentControlIndexChanged(_ sender: UISegmentedControl) {
        let numberOfSegments = CGFloat(segmentedControl.numberOfSegments)
        let selectedIndex = CGFloat(sender.selectedSegmentIndex)
        
        segmentUnderlineIndicator.snp.remakeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(4)
            make.height.equalTo(4)
            make.width.equalTo(segmentUnderlineIndicatorWidth())
            make.centerX.equalTo(segmentedControl.snp.centerX).dividedBy(numberOfSegments / CGFloat(3.0 + CGFloat(selectedIndex-1.0)*2.0))
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.segmentUnderlineIndicator.transform = CGAffineTransform.identity
        })
    }
}

// MARK: - Setup
private extension BaseAdminViewController {
    func setupSegmentControl() {
        removeBackgroundAndDivider()
        
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font : TextStyle.H3.font, NSAttributedString.Key.foregroundColor: UIColor.gray_400], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font : TextStyle.H3.font, NSAttributedString.Key.foregroundColor: UIColor.gray_1200], for: .selected)
    }
    
    /// 기본 Segment UI 제거
    private func removeBackgroundAndDivider() {
        let image = UIImage()
        segmentedControl.setBackgroundImage(image, for: .normal, barMetrics: .default)
        segmentedControl.setBackgroundImage(image, for: .selected, barMetrics: .default)
        segmentedControl.setBackgroundImage(image, for: .highlighted, barMetrics: .default)
        segmentedControl.setDividerImage(image, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
    }
}

// MARK: - UI
private extension BaseAdminViewController {
    
    func configureUI() {
        view.backgroundColor = .background
    }
    
    func configureLayout() {
        segmentContainerView.addSubviews([segmentedControl, segmentUnderlineIndicator])
        view.addSubviews([navigationBarView, segmentContainerView])
        
        navigationBarView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset(44)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        segmentContainerView.snp.makeConstraints { make in
            make.top.equalTo(navigationBarView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(10)
            make.height.equalTo(36)
        }

        segmentedControl.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(28)
        }
        
        segmentUnderlineIndicator.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(4)
            make.height.equalTo(4)
            make.width.equalTo(segmentUnderlineIndicatorWidth())
            make.centerX.equalTo(segmentedControl.snp.centerX).dividedBy(segmentedControl.numberOfSegments)
        }
    }
    
    func segmentUnderlineIndicatorWidth() -> CGFloat {
        guard let title = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex) else {
            return 0
        }
        let titleSize = (title as NSString).size(withAttributes: [.font: TextStyle.H3.font])
        return titleSize.width
    }
}
