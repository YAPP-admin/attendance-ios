//
//  AdminBottomSheetView.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/04/01.
//

import SnapKit
import UIKit

final class AdminBottomSheetView: UIView {

    enum Constants {
        static let padding: CGFloat = 24
        static let cornerRadius: CGFloat = 20
    }

    private let sheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.setTopCornerRadius(radius: Constants.cornerRadius)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        print(bounds)
        sheetView.snp.updateConstraints {
            $0.height.equalTo(273)
        }
    }

}

// MARK: - UI
extension AdminBottomSheetView {

    private func configureUI() {
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
    }

    func configureLayout() {
        addSubview(sheetView)

        sheetView.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.height.equalTo(0)
        }
    }

}
