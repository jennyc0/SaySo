//
//  Functions.swift
//  SaySo
//
//  Created by Jenny Choi on 5/20/25.
//
import SwiftUI

// passes a list of [Post] that fit the condition (public/private posts) 
func getPosts(publicPost: Bool, completion: @escaping ([Post]) -> Void){
    // construct URL with query params
    var components = URLComponents(string: "https://8dtu6dj0w6.execute-api.us-west-2.amazonaws.com/questions")
    components?.queryItems = [URLQueryItem(name: "publicPost", value: String(publicPost))]
    
    guard let url = components?.url else {
        print("Invalid URL")
        return
    }
    
    // create GET request
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
     
    // send the request
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let data = data {
            do {
                let posts = try JSONDecoder().decode([Post].self, from: data) // list of posts
                print("Fetched \(posts.count), publicPost = \(String(publicPost))")
                completion(posts)
            } catch {
                print("Failed to decode posts:", error)
                completion([])
            }
        } else if let error = error {
            print("Error fetching posts:", error)
            completion([])

        }
    }.resume()

}




