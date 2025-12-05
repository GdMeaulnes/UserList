//
//  MainViewModelSwiftTestingTests.swift
//  UserList
//
//  Created by Richard DOUXAMI on 05/12/2025.
//

import Foundation
import Testing
@testable import UserList

final class MockUserListRepository: UserListRepository {
    var mockUsers: [User] = []
    var shouldThrowError = false

    override func fetchUsers(quantity: Int) async throws -> [User] {
        if shouldThrowError {
            throw URLError(.badServerResponse)
        }
        return mockUsers
    }
}


@Test("Les users sont bien chargés par la func fetchUsers")
func testFetchUsersSuccess() async {
    // GIVEN
    let mock = MockUserListRepository()
    mock.mockUsers = sampleUsers

    let vm = MainViewModel(repository: mock)

    // WHEN
    vm.fetchUsers()
    try? await Task.sleep(nanoseconds: 200_000_000) // petite attente

    // THEN
    #expect(vm.isLoading == false)
    #expect(vm.users.count == sampleUsers.count)
}

@Test("shouldLoadMoreData est true pour le dernier utilisateur")
func testShouldLoadMoreDataLastItem() {
    let user1 = sampleUser1
    let user2 = sampleUser2

    let vm = MainViewModel(repository: MockUserListRepository())
    vm.users = [user1, user2]
    vm.isLoading = false

    #expect(vm.shouldLoadMoreData(currentItem: user2))
}

@Test("reloadUsers vide puis recharge la liste")
func testReloadUsers() async {
    let mock = MockUserListRepository()
    mock.mockUsers = [sampleUser1]

    let vm = MainViewModel(repository: mock)
    vm.users = [sampleUser2]

    await vm.reloadUsers()
    try? await Task.sleep(nanoseconds: 200_000_000)

    #expect(vm.users.count == 1)
    // est-ce le bon ?
}
