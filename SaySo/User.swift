//
//  User.swift
//  SaySo
//
//  Created by Jenny Choi on 5/21/25.
//

import Foundation

struct User: Codable, Identifiable {
    var id: String
    var email: String
    private var friends: Set<String> // store user ids
    
    init(email: String) {
        self.id = UUID().uuidString
        self.email = email
        self.friends = []
    }
    
    // function to add friend
    mutating func addFriend(friendID: String) {
        self.friends.insert(friendID)
    }
}
