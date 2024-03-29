//
//  Array.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/05/04.
//

import Foundation

extension Array {

    subscript(safe index: Int) -> Element? {
        get {
            return indices ~= index ? self[index] : nil
        }
        set {
            guard indices ~= index else { return }
            self[safe: index] = newValue
        }
    }

}

extension Array where Element: Equatable {

    mutating func toggleElement(_ element: Element) {
        if let index = self.firstIndex(where: { $0 == element }) {
            self.remove(at: index)
        } else {
            self.append(element)
        }
    }

}
