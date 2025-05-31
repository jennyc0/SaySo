//
//  APIService.swift
//  SaySo
//
//  Created by Jenny Choi on 5/20/25.
//
import Foundation

enum APIError: Error {
    case invalidURL
    case encodingFailed
    case decodingFailed
    case requestFailed
    case invalidResponse
}
struct APIService {
    // one instance of APIService shared throughout the app
    static let shared = APIService()
    private init() {}
    
    func usernameExists(_ username: String) async throws -> Bool {
        guard let url = URL(string: "https://8dtu6dj0w6.execute-api.us-west-2.amazonaws.com/users?username=\(username)") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, _) = try await URLSession.shared.data(for: request) // send request
        
        do {
            let dataDict = try JSONDecoder().decode([String: Bool].self, from: data)
            
            return dataDict["exists"] ?? false
        } catch {
            throw APIError.decodingFailed
        }
 
    }
    
    func createQuestion(userId: String, postVisibility: String, questionText: String) async throws -> Bool {
        let publicPost = (postVisibility == "public")

        // target url to send the request to
        guard let url = URL(string: "https://8dtu6dj0w6.execute-api.us-west-2.amazonaws.com/questions") else {
            throw APIError.invalidURL
        }
        
        let post = Post(userId: userId, text: questionText, publicPost: publicPost)
        guard let body = try? JSONEncoder().encode(post) else {
            throw APIError.encodingFailed
        }
        
        // request is the event that is passed to lambda_handler
        var request = URLRequest(url: url)
        request.httpMethod = "POST" // method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // header
        request.httpBody = body

        // Send the request
        let (_, response) = try await URLSession.shared.data(for: request)
        
        // check HTTP status
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        return true
    }
    
    // passes a list of [Post] that fit the condition (public/private posts)
    func getPosts(publicPost: Bool) async throws -> [Post] {
        guard let url = URL(string: "https://8dtu6dj0w6.execute-api.us-west-2.amazonaws.com/questions") else {
            throw APIError.invalidURL
        }
        
        // create GET request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // send the request
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            let posts = try JSONDecoder().decode([Post].self, from: data) // creats a list of posts
            return posts
        } catch {
            throw APIError.decodingFailed
        }
        
    }
}
