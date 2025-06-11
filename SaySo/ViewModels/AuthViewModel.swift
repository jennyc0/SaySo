//
//  AuthViewModel.swift
//  SaySo
//
//  Created by Jenny Choi on 5/28/25.
//

import Foundation
import Amplify
import AWSCognitoAuthPlugin
import AWSPluginsCore


// different log-in states you can be in
enum AuthState {
    case signUp
    case login
    case confirmCode(email: String, password: String)
    case loggedIn
}

final class AuthViewModel: ObservableObject {
    @Published var authState: AuthState = .signUp
    @Published var currentUser: User? = nil
    @Published var idToken: String? = nil
    @Published var sessionInit = false
    
    init() {
        Task {
            await fetchAuthSession()
        }
    }
    
    //check if user is signed in. if not direct to sign in page
    func fetchAuthSession() async {
        do {
            let session = try await Amplify.Auth.fetchAuthSession()
            if let cognitoTokenProvider = session as? AuthCognitoTokensProvider {
                let tokens = try cognitoTokenProvider.getCognitoTokens().get()
                //let accessToken = tokens.accessToken
                let idToken = tokens.idToken // for getting friendsIds
                
                if session.isSignedIn {
                    DispatchQueue.main.async {
                        self.authState = .loggedIn
                    }
                    do {
                        let attributes = try await Amplify.Auth.fetchUserAttributes() // returns a [AuthUserAttributes(key: __, value: __)]
                        let email = attributes.first(where: { $0.key.rawValue == "email" })?.value ?? ""
                        let username = attributes.first(where: {$0.key.rawValue == "custom:username"})?.value ?? ""
                        let userId = attributes.first(where:{ $0.key.rawValue == "sub"})?.value ?? ""
                        
                        APIService.shared.setIdToken(idToken)
                        // get list of friends ids from dynamodb Users-dev table
                        let friendsIds = try await APIService.shared.getFriends(field: "friends")
                        let friendReqSent = try await APIService.shared.getFriends(field: "friendRequestsSent")
                        let friendReqReceived = try await APIService.shared.getFriends(field: "friendRequestsReceived")
                        DispatchQueue.main.async {
                            self.currentUser = User(email: email, username: username, userId: userId, friends: friendsIds, friendRequestsSent: friendReqSent, friendRequestsReceived: friendReqReceived)
                            print("current user:\(self.currentUser?.id ?? "") ")
                            self.idToken = idToken
                            self.sessionInit = true
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.authState = .login
                    }
                }
            }
            
        } catch {
            print("Failed to fetch session: \(error)")
        }
    }
    
     
    func signUp(email: String, password: String, username: String) async {
        do {
            let emailLower = email.lowercased()
            let usernameLower = username.lowercased()
            
            let nextStep = try await AuthService.shared.signUp(email: emailLower, password: password, username: usernameLower)
            if case let .confirmUser(deliveryDetails, _, userId) = nextStep {
                print("Delivery details \(String(describing: deliveryDetails)) for userId: \(String(describing: userId))")
                DispatchQueue.main.async {
                    self.authState = .confirmCode(email: emailLower, password: password)
                }
            } else {
                print("SignUp Complete")
            }
        } catch let error as AuthError{
            print("An error occured while registering a user: \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    // username is email
    func confirmSignUp(confirmationCode: String) async {
        guard case let .confirmCode(email, password) = authState else {
            print("not in confirm code state")
            return
        }
         
        do {
            let result = try await AuthService.shared.confirmSignUp(for: email, with: confirmationCode)
            if result.isSignUpComplete {
                print("Sign up confirmed and complete")
                await MainActor.run {
                    self.authState = .loggedIn

                }
                
            } else {
                print("sign up confirmed but not complete ")
            }
            
            switch self.authState {
            case .loggedIn:
                let _ = await signIn(username: email, password: password)
            default:
                print("Failed to log in")
                return
            }
            
            
        } catch let error as AuthError{
            print("AuthError: \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
        
    }
    
    //username is email
    func signIn(username: String, password: String) async -> String? {
        do {
            let emailLower = username.lowercased()
            
            let result = try await AuthService.shared.signIn(username: emailLower, password: password)
            if result.isSignedIn {
                print("Sign in succeeded")
                await fetchAuthSession()
            }
        } catch let error as AuthError {
            print("Sign in failed \(error)")
            return "Incorrect username or password"
        } catch {
            print("Unexpected error: \(error)")
        }
        return nil
    }
    
    
    func signOut() async {
        let result = await AuthService.shared.signOut()
        guard let signOutResult = result as? AWSCognitoSignOutResult
        else {
            print("sign out failed")
            return
        }
        switch signOutResult {
        case .complete:
            print("successful sign out")
            DispatchQueue.main.async{
                self.authState = .login
                self.sessionInit = false
            }
            
        case let .partial(revokeTokenError, globalSignOutError, hostedUIError):
            // Sign Out completed with some errors. User is signed out of the device.
            if let hostedUIError = hostedUIError {
                print("HostedUI error  \(String(describing: hostedUIError))")
            }
            if let globalSignOutError = globalSignOutError {
                // Optional: Use escape hatch to retry revocation of globalSignOutError.accessToken.
                print("GlobalSignOut error  \(String(describing: globalSignOutError))")
            }
            if let revokeTokenError = revokeTokenError {
                // Optional: Use escape hatch to retry revocation of revokeTokenError.accessToken.
                print("Revoke token error  \(String(describing: revokeTokenError))")
            }
        case .failed(let error):
            // Sign Out failed with an exception, leaving the user signed in.
            print("SignOut failed with \(error)")
        }
    }
}
