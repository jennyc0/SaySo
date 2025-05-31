//
//  MainAppRouterView.swift
//  SaySo
//
//  Created by Jenny Choi on 5/29/25.
//

import SwiftUI

struct MainAppRouterView: View {
    @EnvironmentObject var authViewModel: AuthViewModel // get from AuthRouterView

    @StateObject var appViewModel = AppViewModel()
    init() {
        print("currTab =", AppViewModel().currTab)
    }
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
                .onAppear{print("Rendering mainAppRouterView")}
            
        }
        .environmentObject(appViewModel)
        .environmentObject(authViewModel)
    }
    
}

#Preview {
    MainAppRouterView()
        .environmentObject(AuthViewModel())

}
