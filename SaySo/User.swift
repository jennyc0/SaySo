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
    var friends: Set<String> // store userIds
    
    init(username: String, friends: Set<String> = []) {
        self.id = UUID().uuidString
        self.username = username
        self.friends = friends
    }
    
    // add friend
    
}
