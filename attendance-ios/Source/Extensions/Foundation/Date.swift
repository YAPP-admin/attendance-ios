//
//  Date.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/04/21.
//

import Foundation

extension Date {

    /// 날짜를 mm.dd 형식으로 반환합니다.
    func mmdd() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd"
		dateFormatter.locale = Locale(identifier: "ko_KR")
		dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        return dateFormatter.string(from: self)
    }

	/// 날짜를 yyyy-MM-dd 형식으로 반환합니다.
	func yyyymmdd() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		dateFormatter.locale = Locale(identifier: "ko_KR")
		dateFormatter.timeZone = TimeZone(abbreviation: "KST")
		return dateFormatter.string(from: self)
	}

	/// 날짜를 yyyy-MM-dd Date 형식으로 반환합니다.
	func yyyymmdd() -> Date? {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		dateFormatter.locale = Locale(identifier: "ko_KR")
		dateFormatter.timeZone = TimeZone(abbreviation: "KST")
		return dateFormatter.string(from: self).dateYYMMDD()
	}

    /// 현재 날짜에서 시간, 분, 초를 없앤 날짜로 반환합니다.
    func startDate() -> Date? {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else { return nil }
        return date
    }

    /// 현재 날짜가 다른 날짜보다 과거인지를 반환합니다.
    func isPast(than other: Date) -> Bool {
        return self.compare(other) == .orderedDescending
    }

    /// 현재 날짜가 다른 날짜보다 과거인지를 반환합니다.
    /// 다른 날짜가 옵셔널이면 false를 반환합니다.
    func isPast(than other: Date?) -> Bool {
        guard let other = other else { return false }
        return isPast(than: other)
    }
  
    func isPastBeforeFiveMinuate(than other: Date?) -> Bool {
        let calendar = Calendar.current
        guard let other = other,
              let otherDate = calendar.date(byAdding: .minute, value: -5, to: other) else {
          return false
        }
    
      return isPast(than: otherDate)
    }

    /// 현재 날짜가 다른 날짜보다 미래인지를 반환합니다.
    func isFuture(than other: Date) -> Bool {
        return self.compare(other) == .orderedAscending
    }

    /// 현재 날짜가 다른 날짜보다 미래인지를 반환합니다.
    /// 다른 날짜가 옵셔널이면 false를 반환합니다.
    func isFuture(than other: Date?) -> Bool {
        guard let other = other else { return false }
        return isFuture(than: other)
    }
  
  func isFutureBeforeFiveMinuate(than other: Date?) -> Bool {
      let calendar = Calendar.current
      guard let other = other,
            let otherDate = calendar.date(byAdding: .minute, value: -5, to: other) else {
        return false
      }
  
    return self.compare(otherDate) == .orderedAscending
  }

	/// 현재 날짜가 다른 날짜와 같은 날짜인지 반환합니다.
	func isPresent(than other: Date) -> Bool {
		return self.compare(other) == .orderedSame
	}

	/// 현재 날짜가 다른 날짜와 같은 날짜인지 반환합니다.
	/// 다른 날짜가 옵셔널이면 false를 반환합니다.
	func isPresent(than other: Date?) -> Bool {
		guard let other = other else { return false }
		return isPresent(than: other)
	}
}
