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
    
    private var authcontinuation: CheckedContinuation<String, Error>?
    
    lazy var authorizationController: ASAuthorizationController = {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email, .fullName]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        return authorizationController
    }()
     
    func loginWithApple() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            authcontinuation = continuation
            authorizationController.performRequests()
        }
    }
}

extension DefaultAppleAuthRespository: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            do {
                try KeyChainManager.shared.create(account: .userId, data: appleIDCredential.user)
            } catch {
                authcontinuation?.resume(throwing: error)
            }
            
            if let middleName = appleIDCredential.fullName?.middleName,
               let prefixName = appleIDCredential.fullName?.namePrefix {
                authcontinuation?.resume(returning: prefixName + middleName)
            }
        } else {
            authcontinuation?.resume(throwing: YPError.appleAuth)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        authcontinuation?.resume(throwing: YPError.appleAuth)
    }
}

