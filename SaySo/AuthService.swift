//
//  AuthService.swift
//  SaySo
//
//  Created by Jenny Choi on 5/28/25.
//

import Foundation
import Amplify

final class AuthService {
    // one instance of AuthService shared in entire app
    static let shared = AuthService()
    private init() {}
    
    // username is their email
    func signIn(username: String, password: String) async throws -> AuthSignInResult {
        let signInResult = try await Amplify.Auth.signIn(
            username: username,
            password: password
        )
        return signInResult
        
    }
    
    func signUp(email: String, password: String) async throws -> AuthSignUpStep{
        let userAttributes = [AuthUserAttribute(.email, value: email)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        
        let result = try await Amplify.Auth.signUp(
            username: email,
            password: password,
            options: options
        )
        return result.nextStep
    }
    
    // Enter the confirmation code received via email in the confirmSignUp call
    func confirmSignUp(for username: String, with confirmationCode: String) async throws -> AuthSignUpResult {
        let confirmSignUpResult = try await Amplify.Auth.confirmSignUp(
            for: username,
            confirmationCode: confirmationCode
        )
        return confirmSignUpResult
    }
    
    func signOut() async -> AuthSignOutResult {
        let result = await Amplify.Auth.signOut()
        return result
    }
}
