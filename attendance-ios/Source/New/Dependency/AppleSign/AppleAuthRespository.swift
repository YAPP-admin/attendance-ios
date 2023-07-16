//
//  AppleAuthRespository.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/16.
//

import Foundation
import AuthenticationServices

final class DefaultAppleAuthRespository: NSObject {
    
    static let shared = DefaultAppleAuthRespository()
    
    private var authcontinuation: CheckedContinuation<SignInUserModel, Error>?
    
    lazy var authorizationController: ASAuthorizationController = {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email, .fullName]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        return authorizationController
    }()
     
    func loginWithApple() async throws -> SignInUserModel {
        return try await withCheckedThrowingContinuation { continuation in
            authcontinuation = continuation
            authorizationController.performRequests()
        }
    }
}

extension DefaultAppleAuthRespository: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            if let middleName = appleIDCredential.fullName?.middleName,
               let prefixName = appleIDCredential.fullName?.namePrefix {
                let signInUserModel = SignInUserModel(userId: appleIDCredential.user, name: prefixName + middleName)
                authcontinuation?.resume(returning: signInUserModel)
            } else {
                let signInUserModel = SignInUserModel(userId: appleIDCredential.user, name: "")
                authcontinuation?.resume(returning: signInUserModel)
            }
        } else {
            authcontinuation?.resume(throwing: AppleError.unknown)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        authcontinuation?.resume(throwing: AppleError.unknown)
    }
}

enum AppleError: Error {
    case unknown
}

