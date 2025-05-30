//
//  MainAppRouterView.swift
//  SaySo
//
//  Created by Jenny Choi on 5/29/25.
//

import SwiftUI
/*
 enum Tab {
     case profile
     case createPost
     case explore
 }
 */

struct MainAppRouterView: View {
    @StateObject var appViewModel = AppViewModel()
    
    var body: some View {
        
        TabView(selection: $appViewModel.currTab){
            
            ExploreView()
                .tabItem {Image(systemName: "globe.americas")}
                .tag(Tab.explore)
            CreatePostView()
                .tabItem {Image(systemName: "plus.circle")}
                .tag(Tab.createPost)
            ProfileView()
                .tabItem {Image(systemName: "person")}
                .tag(Tab.profile)
            
        }
        .environmentObject(appViewModel)
    }
    
}

#Preview {
    MainAppRouterView()
}
