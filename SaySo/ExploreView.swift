//
//  ExploreView.swift
//  SaySo
//
//  Created by Jenny Choi on 5/19/25.
//  Where all public posts will be displayed

import SwiftUI

struct ExploreView: View {
    var body: some View {
        //getPosts(publicPost: true)
        Text("helloworld")
        
    }
}


func getPosts(publicPost: Bool){ // return json string
    // construct URL with query params
    var components = URLComponents(string: "https://8dtu6dj0w6.execute-api.us-west-2.amazonaws.com/questions")
    components?.queryItems = [URLQueryItem(name: "publicPost", value: String(publicPost))]
    
}
#Preview {
    ExploreView()
}
