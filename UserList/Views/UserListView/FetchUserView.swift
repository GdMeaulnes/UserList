//
//  FetchUserView.swift
//  UserList
//
//  Created by Richard DOUXAMI on 06/11/2025.
//

import SwiftUI


struct FetchUserView: View {
    
    // Récupération du viewModel
    @EnvironmentObject var viewModel: MainViewModel
    @Binding var selectedPresentation: MainView.SelectedPresentation
    
    var body: some View {
        // Wrap pour pouvoir lancer le reload via une task
        VStack(spacing: 12) {
            ProgressView()
            Text("Loading...")
        }
        .task {
            await viewModel.reloadUsers()
            // On repositionne le sélecteur à la valeur d'appel
            selectedPresentation = .GridPresentation
        }
    }
}

struct FetchUserView_Previews: PreviewProvider {
    static var previews: some View {
        FetchUserView(selectedPresentation: .constant(.GridPresentation))
            .environmentObject(MainViewModel.preview)
    }
}
