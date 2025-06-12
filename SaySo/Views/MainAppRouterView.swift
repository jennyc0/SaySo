//
//  MainAppRouterView.swift
//  SaySo
//
//  Created by Jenny Choi on 5/29/25.
//

import SwiftUI

struct MainAppRouterView: View {
    
    // get from AuthRouterView
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    var body: some View {
        
        TabView(selection: $appViewModel.currTab){
            if authViewModel.sessionInit {
                ExploreView()
                    .tabItem {Image(systemName: "globe.americas")}
                    .tag(Tab.explore)
                FriendsView()
                    .tabItem {Image(systemName: "person.2")}
                    .tag(Tab.friends)
                CreatePostView()
                    .tabItem {Image(systemName: "plus.circle")}
                    .tag(Tab.createPost)
                NotificationsView()
                    .tabItem {Image(systemName: "bell")}
                    .tag(Tab.notifications)
                ProfileView()
                    .tabItem {Image(systemName: "person")}
                    .tag(Tab.profile)
            }
            
            
        }
        .environmentObject(appViewModel)
        .environmentObject(authViewModel)
    }
    
}

#Preview {
    MainAppRouterView()
        .environmentObject(AuthViewModel())
        .environmentObject(AppViewModel())

}
