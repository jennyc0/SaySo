//
//  User.swift
//  SaySo
//
//  Created by Jenny Choi on 5/21/25.
//

import Foundation

struct User: Codable, Identifiable, Equatable {
    var userId: String
    var id: String {userId}
    var username: String
    var email: String
    
    var friends: Array<String> // store user ids
    var friendRequestsSent: Array<String>
    var friendRequestsReceived: Array<String>
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.userId == rhs.userId
    }
    
    init(email: String, username: String, userId: String, friends: [String] = [], friendRequestsSent: [String] = [], friendRequestsReceived: [String] = []) {
        self.userId = userId // the "sub" of the user pool
        self.username = username
        self.email = email
        self.friends = friends
        self.friendRequestsSent = friendRequestsSent
        self.friendRequestsReceived = friendRequestsReceived
        
    }
}
