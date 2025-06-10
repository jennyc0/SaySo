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
    
    var friends: Array<String> // store user ids
    var friendRequestsSent: Array<String>
    var friendRequestsReceived: Array<String>
    
    init(email: String, username: String, userId: String, friends: [String] = [], friendRequestsSent: [String] = [], friendRequestsReceived: [String] = []) {
        self.id = userId // the "sub" of the user pool
        self.username = username
        self.email = email
        self.friends = friends
        self.friendRequestsSent = friendRequestsSent
        self.friendRequestsReceived = friendRequestsReceived
        
    }
    
    // function to add friend
    mutating func addFriend(friendID: String) {
        self.friends.append(friendID)
    }
}
