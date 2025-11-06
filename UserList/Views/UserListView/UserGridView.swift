//
//  UserGridView.swift
//  UserList
//
//  Created by Richard DOUXAMI on 02/11/2025.
//

import SwiftUI

struct UserGridView: View {
    
    // One bunch of users
    let users: [User]
    
    let guides = [
        GridItem(.adaptive(minimum: 100)),
        GridItem(.adaptive(minimum: 100))
    ]
                
    var body: some View {
        
//        NavigationStack {
            ScrollView {
                LazyVGrid(columns: guides, spacing: 10) {
                    ForEach(users) { user in
                        NavigationLink(destination: UserDetailView(user: user)) {
                            VStack {
                                AsyncImage(url: URL(string: user.picture.medium)) { result in
                                    
                                    switch result {
                                    case .empty:
                                        ProgressView()
                                            .frame(width: 150, height: 150)
                                        
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 150, height: 150)
                                            .clipShape(Circle())
                                        
                                    case .failure:
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(.secondary.opacity(0.15))
                                            Image(systemName: "photo")
                                                .imageScale(.large)
                                                .foregroundStyle(.secondary)
                                        }
                                        .aspectRatio(1, contentMode: .fit)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                                Text("\(user.name.first) \(user.name.last)")
                                    .font(.subheadline)
                                    .foregroundStyle(Color(.label))
                            }
                        }
                    }
                }
            }
            .navigationTitle("Users - Grid Mode")
//        }
    }
    
}

struct UserGridView_Previews: PreviewProvider {
    static var previews: some View {
        UserGridView(users: sampleUsers)
    }
}

