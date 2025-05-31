//
//  CreatePostView.swift
//  SaySo
//
//  Created by Jenny Choi on 5/17/25.
//

import SwiftUI

struct CreatePostView: View {
   // @EnvironmentObject var authViewModel: AuthViewModel 
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
                            let success = try await APIService.createQuestion(postVisibility: "public", questionText: questionText)
                            if success {
                                // reset frontend variables
                                newQ = true
                                questionText = ""
                            }
                        } catch {
                            print("Error: ", error)
                            
                        }
                    }
                }
                Button("Ask Friends") {
                    Task {
                        do {
                            let success = try await APIService.createQuestion(postVisibility: "private", questionText: questionText)
                            if success {
                                // reset frontend variables
                                newQ = true
                                questionText = ""
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
                // show confirmation on console log
                Text("Question submitted")
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    CreatePostView()
}
