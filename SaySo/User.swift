//
//  User.swift
//  SaySo
//
//  Created by Jenny Choi on 5/21/25.
//

import Foundation

struct User: Codable, Identifiable {
    var id: String
    var username: String
    var email: String
    private var friends: Array<String> // store user ids
    
    init(email: String, username: String, userId: String) {
        //self.id = UUID().uuidString
        self.id = userId // the "sub" of the user pool
        self.username = username
        self.email = email
        self.friends = []
    }
    
    // function to add friend
    mutating func addFriend(friendID: String) {
        self.friends.append(friendID)
    }
}
