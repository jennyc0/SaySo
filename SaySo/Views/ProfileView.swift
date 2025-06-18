//
//  ProfileView.swift
//  SaySo
//
//  Created by Jenny Choi on 5/29/25.
//
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: - Top Header Row
                HStack(alignment: .top, spacing: 16) {
                    // Profile Picture
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))
                    
                    VStack(alignment: .leading, spacing: 8) {
                        // Username and Edit Button
                        HStack {
                            Text(authViewModel.currentUser?.username ?? "username")
                                .font(.headline)
                            Spacer()
                            Button(action: {
                                // TODO Edit profile logic
                            }) {
                                Text("Edit Profile")
                                    .font(.subheadline)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                            }
                        }
                        
                        // TODO Post + Friends Count
                        HStack(spacing: 24) {
                            StatItem(count: "12", label: "Posts")
                            StatItem(count: "\(authViewModel.currentUser?.friends.count ?? 0)", label: "Friends")
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top)

                // MARK: - Bio Section
                Text("bioooo")
                    .font(.body)
                    .padding(.horizontal)

                Divider()
                
                // MARK: - Navigation Buttons
                VStack(spacing: 12) {
                    Button(action: {}) {
                        ProfileActionButton(icon: "person.2.fill", title: "View Friends")
                    }

                    Button(action: {}) {
                        ProfileActionButton(icon: "list.bullet", title: "My Questions")
                    }

                    Button(action: {}) {
                        ProfileActionButton(icon: "envelope.badge", title: "Friend Requests")
                    }
                }
                .padding(.horizontal)

                Spacer()

                // MARK: - Sign Out Button
                Button(role: .destructive) {
                    Task {
                        await authViewModel.signOut()
                    }
                } label: {
                    Text("Sign Out")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Helper Views

struct StatItem: View {
    let count: String
    let label: String

    var body: some View {
        VStack {
            Text(count)
                .font(.subheadline)
                .fontWeight(.semibold)
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

struct ProfileActionButton: View {
    let icon: String
    let title: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
            Text(title)
                .foregroundColor(.primary)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}


#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
