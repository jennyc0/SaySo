//
//  SearchView.swift
//  SaySo
//
//  Created by Jenny Choi on 6/2/25.
//

import SwiftUI

struct SearchView: View {
    
    
    @State private var searchQuery: String = ""
    @State private var matchingUsers: [User] = []
    @State var loadingUsers: Bool = false

    var body: some View {
        VStack {
            TextField("Search by username", text: $searchQuery) {
                
            }
            .onChange(of: searchQuery) {
                
            }
            
            List(matchingUsers) { user in
                
            }
            
        }
        .padding()
        
    }
}

#Preview {
    SearchView()
}
