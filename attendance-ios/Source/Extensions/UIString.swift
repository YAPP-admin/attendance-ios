//
//  UIString.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/04/21.
//

import UIKit

extension String {

    func date() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: self)
    }

}
