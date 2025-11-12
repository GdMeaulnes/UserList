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
        // Wrap pour pouvoir lancer le reload
        VStack(spacing: 12) {
            ProgressView()
            Text("Loading...")
        }
        .task {
            print("Avant \($selectedPresentation)")
            await viewModel.reloadUsers()
            // On repositionne le sélecteur à la valeur d'appel
            selectedPresentation = .ListPresentation
            print("Apres \($selectedPresentation)")
        }
    }
}

// Fabrication d'un viewModel déjà rempli pour la preView
extension MainViewModel {
    static var preview: MainViewModel {
        let vm = MainViewModel()
        vm.users = [sampleUser1, sampleUser2, sampleUser3, sampleUser4]
        vm.isLoading = false
        return vm
    }
}

struct FetchUserView_Previews: PreviewProvider {
    static var previews: some View {
        FetchUserView(selectedPresentation: .constant(.GridPresentation))
            .environmentObject(MainViewModel.preview)
    }
}
