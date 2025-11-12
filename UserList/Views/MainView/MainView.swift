//
//  MainView.swift
//  UserList
//
//  Created by Richard DOUXAMI on 03/11/2025.
//

import SwiftUI

struct MainView: View {
    
    // Sélections possibles pour le TabView
    enum SelectedPresentation {
        case GridPresentation
        case ListPresentation
        case ReloadUsers
    }
    
    @StateObject private var viewModel = MainViewModel()
    
    // Pour asurer le retour dans le même onglet
    @State private var selectedPresentation: SelectedPresentation = .ListPresentation
    
    var body: some View {
        TabView(selection: $selectedPresentation) {
            // Vue en mode liste
            Tab("Users (List)", systemImage: "list.bullet", value: .ListPresentation) {
                NavigationStack {
                    UserListView(users: viewModel.users)
                }
                }
            // Vue en mode grille
            Tab("Users (Grid)", systemImage: "rectangle.grid.1x2.fill", value: .GridPresentation) {
                NavigationStack {
                    UserGridView(users: viewModel.users)
                }
                   }
            // Reload d'un nouveau jeu d'identité. L'ancienne liste disparait
            Tab("Reload Users", systemImage: "arrow.clockwise", value: .ReloadUsers) {
                    FetchUserView(selectedPresentation: $selectedPresentation)
                   }
        }
        // Partage du viewModel
        .environmentObject(viewModel)
        // Premier chargement 
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
