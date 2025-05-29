//
//  SaySoApp.swift
//  SaySo
//
//  Created by Jenny Choi on 5/17/25.
//

import SwiftUI
import Amplify
import AWSCognitoAuthPlugin

@main
struct SaySoApp: App {
    init() {
        configureAmplify()
    }
    var body: some Scene {
        WindowGroup {
            AuthRouterView()
        }
    }
    
    private func configureAmplify() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            print("Amplify configured successfully!")
            
        } catch {
            print("Could not initialize Amplify, error: \(error)")
        }
    }
}
