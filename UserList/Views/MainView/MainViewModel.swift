//
//  MainViewModel.swift
//  UserList
//
//  Created by Richard DOUXAMI on 03/11/2025.
//

import Foundation

final class MainViewModel: ObservableObject {
    
    @Published var users: [User] = []
    @Published var isLoading: Bool = false
    
    private let repository: UserListRepository
    
    init(repository: UserListRepository = UserListRepository()) {
        self.repository = repository
    }
    
     func fetchUsers() {
         
        isLoading = true // On indique que le chargement est en cours
        Task { // On crée une tâche asynchrone compatible avec async/await. Comme une View SwiftUI ne peut pas être async, on utilise Task pour lancer du code asynchrone depuis une fonction “classique”.
            do {
                // Appel du UserListRepository, pour construire l'URLRequest (randomuser.me/api/?results=20) et décode la réponse JSON en [User].
                let users = try await repository.fetchUsers(quantity: 20)
                
                // On ajoute les nouveaux utilisateurs à la liste existante.
                self.users.append(contentsOf: users)
                isLoading = false
            } catch {
                isLoading = false // Correction du code existant pour que même sur une sortie en erreur isLoading soit à False
                print("Error fetching users: \(error.localizedDescription)")
            }
        }
    }
        
    // Fonction d'"infinite scroll".
    func shouldLoadMoreData(currentItem item: User) -> Bool {
        // Si la liste est vide, on ne charge rien (false). Sinon, lastItem représente le dernier utilisateur de la liste.
        guard let lastItem = users.last else { return false }
        return !isLoading && item.id == lastItem.id
    }
    
    // Fonction "pull to refresh"
    func reloadUsers() async {
        users.removeAll()
        fetchUsers()
    }
    
}

