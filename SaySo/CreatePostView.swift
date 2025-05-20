//
//  CreatePostView.swift
//  SaySo
//
//  Created by Jenny Choi on 5/17/25.
//

import SwiftUI

struct CreatePostView: View {
    @State private var questionText = ""
    @State private var newQ = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("New post")
                .font(.title2)
            
            TextField("What's your dilemma?", text: $questionText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            HStack() {
                Button("Ask the World") {
                    createQuestion(postVisibility: "public") // public post
                }
                
                Button("Ask Friends") {
                    createQuestion(postVisibility: "private") // private post
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
    // store new post in DynamoDB database
    func createQuestion(postVisibility: String) {
        var publicPost = false
        if postVisibility == "public" {
            publicPost = true
        }
        // target url to send the request to
        guard let url = URL(string: "https://8dtu6dj0w6.execute-api.us-west-2.amazonaws.com/questions") else { return }
        
        let post = Post(text: questionText, publicPost: publicPost)
        guard let body = try? JSONEncoder().encode(post) else {
            print("Failed to encode post")
            return
        }
        // request is the event that is passed to lambda_handler
        var request = URLRequest(url: url)
        request.httpMethod = "POST" // method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // header
        
        request.httpBody = body
        
        // Send the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let message = json["message"] as? String {
                print("Response from Lambda:", message)
            } else {
                print("Invalid or no response")
            }
            
            if let error = error {
                print("Error making request:", error)
                return
            }
                
        }.resume()
        
        // reset frontend variables
        newQ = true
        questionText = ""
        
    }
}

#Preview {
    CreatePostView()
}
