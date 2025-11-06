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
    
    func fetchUsers() {
        isLoading = true
        print("dans fetch")
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

    
    
    private let repository = UserListRepository()
    
     func reloadUsers() {
        print("dans reload")
        users.removeAll()
        fetchUsers()
    }
    
}
