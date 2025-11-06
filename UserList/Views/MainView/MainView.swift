//
//  MainView.swift
//  UserList
//
//  Created by Richard DOUXAMI on 03/11/2025.
//

import SwiftUI

struct MainView: View {
    
    // Sélection Possible selection
    enum SelectedPresentation {
        case GridPresentation
        case ListPresentation
        case FetchingUsers
    }
    
    @StateObject private var viewModel = MainViewModel()
    
    @State private var selectedPresentation: SelectedPresentation = .ListPresentation
    
    var body: some View {
        TabView(selection: $selectedPresentation) {
            Tab("Users (List)", systemImage: "list.bullet", value: .ListPresentation) {
                NavigationStack {
                    UserListView(users: viewModel.users)
                }
                }

            Tab("Users (Grid)", systemImage: "rectangle.grid.1x2.fill", value: .GridPresentation) {
                NavigationStack {
                    UserGridView(users: viewModel.users)
                }
                   }

            Tab("Fetch Users", systemImage: "arrow.clockwise", value: .FetchingUsers) {
                    FetchUserView()
                   }
        }
        .onAppear {
            if viewModel.users.isEmpty {
                viewModel.fetchUsers()
            }
        }
    }
}


#Preview {
    MainView()
}
