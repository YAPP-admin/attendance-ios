//
//  SignUpUserModel.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/16.
//

import Foundation

struct SignInUserModel {
    let userId: String
    let name: String
    
    init(userId: String, name: String) {
        self.userId = userId
        self.name = name
    }
}
