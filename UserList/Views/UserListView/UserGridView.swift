//
//  UserGridView.swift
//  UserList
//
//  Created by Richard DOUXAMI on 02/11/2025.
//

import SwiftUI

struct UserGridView: View {
    
    @EnvironmentObject var viewModel: MainViewModel
    
    let guides = [
        GridItem(.adaptive(minimum: 100)),
        GridItem(.adaptive(minimum: 100))
    ]
                
    var body: some View {
        
            ScrollView {
                LazyVGrid(columns: guides, spacing: 10) {
                    ForEach(viewModel.users) { user in
                        NavigationLink(destination: UserDetailView(user: user)) {
                            VStack {
                                AsyncImage(url: URL(string: user.picture.large)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 150, height: 150)
                                        .clipShape(Circle())
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: 150, height: 150)
                                        .clipShape(Circle())
                                }
                                
                                Text("\(user.name.first) \(user.name.last)")
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                            }

                        }
                        // Lorsque la dernière vue est affichée, on charge à la suite un paquet de plus
                        .onAppear {
                            if viewModel.shouldLoadMoreData(currentItem: user) {
                                viewModel.fetchUsers()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Users - Grid Mode")
    }
    
}

struct UserGridView_Previews: PreviewProvider {
    static var previews: some View {
        //UserGridView(users: sampleUsers)
        UserGridView()
    }
}

