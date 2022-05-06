//
//  PrintFn.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/05/04.
//

import Foundation

public func print(_ object: Any) {
    #if DEBUG
    Swift.print("👉\(object)")
    #endif
}
