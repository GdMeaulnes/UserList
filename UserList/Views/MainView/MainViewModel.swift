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
    
    private let repository = UserListRepository()
    
     func fetchUsers() {
        isLoading = true
        Task {
            do {
                let users = try await repository.fetchUsers(quantity: 20)
                self.users.append(contentsOf: users)
                isLoading = false
            } catch {
                print("Error fetching users: \(error.localizedDescription)")
            }
        }
    }
        
    
    private func shouldLoadMoreData(currentItem item: User) -> Bool {
        guard let lastItem = users.last else { return false }
        return !isLoading && item.id == lastItem.id
    }
    
    func reloadUsers() async {
        users.removeAll()
        fetchUsers()
    }
    
}


