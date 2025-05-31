//
//  AuthViewModel.swift
//  SaySo
//
//  Created by Jenny Choi on 5/28/25.
//

import Foundation
import Amplify
import AWSCognitoAuthPlugin


// different log-in states you can be in
enum AuthState {
    case signUp
    case login
    case confirmCode(email: String)
    case loggedIn
}

final class AuthViewModel: ObservableObject {
    @Published var authState: AuthState = .signUp
    @Published var currentUser: User? = nil
    
    init() {
        Task {
            await fetchAuthSession()
        }
    }
    
    //check if user is signed in. if not direct to sign in page
    func fetchAuthSession() async {
        do {
            let session = try await Amplify.Auth.fetchAuthSession()
            if session.isSignedIn {
                DispatchQueue.main.async {
                    self.authState = .loggedIn
                }
                do {
                    let attributes = try await Amplify.Auth.fetchUserAttributes()
                    let email = attributes.first(where: { $0.key.rawValue == "email" })?.value ?? ""
                    DispatchQueue.main.async {
                        self.currentUser = User(email: email) 
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.authState = .login
                }
            }
        } catch {
            print("Failed to fetch session: \(error)")
        }
    }
    
     
    func signUp(email: String, password: String) async {
        do {
            let nextStep = try await AuthService.shared.signUp(email: email, password: password)
            if case let .confirmUser(deliveryDetails, _, userId) = nextStep {
                print("Delivery details \(String(describing: deliveryDetails)) for userId: \(String(describing: userId))")
                DispatchQueue.main.async {
                    self.authState = .confirmCode(email: email)
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
        guard case let .confirmCode(email) = authState else {
            print("not in confirm code state")
            return
        }
         
        do {
            let result = try await AuthService.shared.confirmSignUp(for: email, with: confirmationCode)
            if result.isSignUpComplete {
                print("Sign up confirmed and complete")
                DispatchQueue.main.async {
                    self.authState = .loggedIn
                }

            } else {
                print("sign up confirmed but not complete ")
            }
        } catch let error as AuthError{
            print("AuthError: \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
        
    }
    
    //username is email
    func signIn(username: String, password: String) async {
        do {
            let result = try await AuthService.shared.signIn(username: username, password: password)
            if result.isSignedIn {
                print("Sign in succeeded")
                
                DispatchQueue.main.async {
                    self.authState = .loggedIn
                }
            }
        } catch let error as AuthError {
            print("Sign in failed \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
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
