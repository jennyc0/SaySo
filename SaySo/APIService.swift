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
    case missingToken
}
class APIService {
    // one instance of APIService shared throughout the app
    static let shared = APIService()
    private init() {}
    
    var idToken: String? = nil
    
    func getUser(userId: String) async throws -> User {
        guard let url = URL(string: "https://8dtu6dj0w6.execute-api.us-west-2.amazonaws.com/users/\(userId)") else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        let (data, _) = try await URLSession.shared.data(for: request)
        do {
            let user = try JSONDecoder().decode(User.self, from: data)
            return user 
        } catch {
            throw APIError.decodingFailed
        }
 
    }
    
    func changeVoteCount(postId: String, voteYes: Bool, delta: Int) async throws -> Bool {
        guard let url = URL(string: "https://8dtu6dj0w6.execute-api.us-west-2.amazonaws.com/questions") else {
            throw APIError.invalidURL
        }
        let vote = Vote(postId: postId, vote: voteYes ? "yes" : "no", delta: delta)
        guard let body = try? JSONEncoder().encode(vote) else {
            throw APIError.encodingFailed
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        return true
        
    }
    func logVote(postId: String, userId: String, voteYes: Bool) async throws -> Bool {
        // use idToken to store id of the user voting
        guard let url = URL(string: "https://8dtu6dj0w6.execute-api.us-west-2.amazonaws.com/votes") else {
            throw APIError.invalidURL
        }
        
        let vote = Vote(postId: postId, userId: userId, vote: voteYes ? "yes" : "no", delta: 1)
        guard let body = try? JSONEncoder().encode(vote) else {
            throw APIError.encodingFailed
        }
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        return true 
        
    }
    func setIdToken(_ idToken: String?) {
        self.idToken = idToken
    }
    
    func getFriends(field: String) async throws -> [String] { //returns list of friends' userIds
        // can get 3 different fields
        //field = friendRequestsSent, friendRequestsReceived, friends
        
        guard let url = URL(string: "https://8dtu6dj0w6.execute-api.us-west-2.amazonaws.com/users/friends?field=\(field)") else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(self.idToken ?? "")", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        do {
            let dataDict = try JSONDecoder().decode([String: [String]].self, from: data)
            return dataDict[field] ?? []
        } catch {
            throw APIError.decodingFailed
        }
    }
    
    // if vote exists, return the vote value
    func voteExists(postId: String) async throws -> (Bool, String) {
        struct VoteResponse: Decodable {
            let voted: Bool
            let vote: Bool?
        }
        guard let url = URL(string: "https://8dtu6dj0w6.execute-api.us-west-2.amazonaws.com/votes/\(postId)") else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(self.idToken ?? "")", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        do {
            let response = try JSONDecoder().decode(VoteResponse.self, from: data)
            
            if response.voted {
                if let vote = response.vote {
                    return (true, vote ? "yes" : "no")
                }
            } else {
                return (false, "")
            }
            
        } catch {
            throw APIError.decodingFailed
        }
        return (false, "")
    }
    
    // returns updated value of currentUser 
    func sendFriendRequest(to friendId: String) async throws -> User {
        guard let url = URL(string: "https://8dtu6dj0w6.execute-api.us-west-2.amazonaws.com/users/\(friendId)/friend-requests") else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url:url)
        request.httpMethod = "PATCH"
        guard let token = self.idToken, !token.isEmpty else {
            throw APIError.missingToken
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                
        let (data, response) = try await URLSession.shared.data(for: request)
        print("Finished sending request")
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            //print("Status Code: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
            throw APIError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(User.self, from: data)
        } catch {
            throw APIError.decodingFailed
        }
        
    }
    
    // return updated user (updated [friends] data member)
    func acceptFriendRequest(friendId: String) async throws -> User {
        print("Sending friendId: \(friendId)")
        guard let url = URL(string: "https://8dtu6dj0w6.execute-api.us-west-2.amazonaws.com/users/\(friendId)/friend-requests/accept" ) else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url:url)
        request.httpMethod = "PATCH"
        guard let token = self.idToken, !token.isEmpty else {
            throw APIError.missingToken
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        print("Finished sending request")
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print("Status Code: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
            throw APIError.invalidResponse
        }
        do {
            return try JSONDecoder().decode(User.self, from: data)
        } catch {
            throw APIError.decodingFailed
        }
    }
    // get results for looking up a username
    func userSearchQuery(_ query: String) async throws -> [User] {
        guard let url = URL(string: "https://8dtu6dj0w6.execute-api.us-west-2.amazonaws.com/users/search?query=\(query)" ) else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        
        let (data, _) = try await URLSession.shared.data(for: request) // send request
        
        //let jsonString = String(data: data, encoding: .utf8)
        //print("Raw JSON: \(jsonString ?? "nil")")

        do {
            return try JSONDecoder().decode([User].self, from: data)
        } catch {
            throw APIError.decodingFailed
        }
        
    }
    
    
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
    
    // gets a singular post to update
    func getPost(postId: String) async throws -> Post {
        guard let url = URL(string: "https://8dtu6dj0w6.execute-api.us-west-2.amazonaws.com/questions/\(postId)") else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        let (data, _) = try await URLSession.shared.data(for: request)
        do {
            let post = try JSONDecoder().decode(Post.self, from: data)
            return post
        } catch {
            throw APIError.decodingFailed
        }
    }
    // returns list of public posts or user's friends' friend-only posts
    // need idToken for getting non-public posts
    func getPosts(publicPost: Bool) async throws -> [Post] {
        
        let urlString: String
        if publicPost {
            urlString = "https://8dtu6dj0w6.execute-api.us-west-2.amazonaws.com/questions?publicPost=true"
        } else {
            urlString = "https://8dtu6dj0w6.execute-api.us-west-2.amazonaws.com/questions?publicPost=false"
        }
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        // create GET request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        guard let token = self.idToken, !token.isEmpty else {
            throw APIError.missingToken
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") // to get friends only posts

        // send the request
        let (data, _) = try await URLSession.shared.data(for: request)
        do {
            //print(String(data: data, encoding: .utf8) ?? "Invalid UTF8")
            let posts = try JSONDecoder().decode([Post].self, from: data) // creats a list of posts
            print(posts)
            return posts
        } catch {
            throw APIError.decodingFailed
        }
    }
    
    
}
