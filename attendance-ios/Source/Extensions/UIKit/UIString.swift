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
		dateFormatter.locale =  Locale(identifier: "ko_KR")
		dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        return dateFormatter.date(from: self)
    }

	func dateYYMMDD() -> Date? {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		dateFormatter.locale =  Locale(identifier: "ko_KR")
		dateFormatter.timeZone = TimeZone(abbreviation: "KST")
		return dateFormatter.date(from: self)
	}

	func stringPrefix(endNum: Int) -> String {
		let strRange = self.index(self.startIndex, offsetBy: 0) ... self.index(self.endIndex, offsetBy: endNum)
		return String(self[strRange])
	}

}
