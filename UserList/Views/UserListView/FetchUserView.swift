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
    
    var body: some View {
        // Wrap pour pouvoir lancer le reload
        VStack(spacing: 12) {
            ProgressView()
            Text("Loading...")
        }
        .task {
            // Trigger the user fetch when the view appears
            await viewModel.reloadUsers()
            print("reload fait")
        }
    }
}


#Preview {
    FetchUserView()
}

