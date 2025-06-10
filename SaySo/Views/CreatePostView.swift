//
//  CreatePostView.swift
//  SaySo
//
//  Created by Jenny Choi on 5/17/25.
//

import SwiftUI

struct CreatePostView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    
    @State private var questionText = ""
    @State private var newQ = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("New post")
                .font(.title2)
            
            TextField("What's your dilemma?", text: $questionText)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            HStack() {
                Button("Ask the World") {
                    Task {
                        do {
                            if let userId = authViewModel.currentUser?.id {
                                let success = try await APIService.shared.createQuestion(userId: userId, postVisibility: "public", questionText: questionText)
                                if success {
                                    // reset frontend variables
                                    newQ = true
                                    questionText = ""
                                }
                            } else {
                                print("No current user")
                            }
                            
                            
                        } catch {
                            print("Error: ", error)
                            
                        }
                    }
                }
                Button("Ask Friends") {
                    Task {
                        do {
                            if let userId = authViewModel.currentUser?.id {
                                let success = try await APIService.shared.createQuestion(userId: userId, postVisibility: "private", questionText: questionText)
                                if success {
                                    // reset frontend variables
                                    newQ = true
                                    questionText = ""
                                }
                            } else {
                                print("No current user")
                            }
                        } catch {
                            print("Error: ", error)
                            
                        }
                    }
                    
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(questionText == "")
        
            if newQ {
                // show confirmation
                Text("Question submitted")
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    CreatePostView()
        .environmentObject(AuthViewModel())
        .environmentObject(AppViewModel())
}
