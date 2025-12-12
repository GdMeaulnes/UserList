//
//  MainViewModelSwiftTestingTests.swift
//  UserList
//
//  Created by Richard DOUXAMI on 05/12/2025.
//

import Foundation
import Testing
@testable import UserList

// Simulation du repository
// Dans les tests, on utilisera les "sample" (user et tableau de user) définis dans User.swift
final class MockUserListRepository: UserListRepository {
    var mockUsers: [User] = []
    var shouldReturnError = false

    override func fetchUsers(quantity: Int) async throws -> [User] {
        if shouldReturnError {
            throw URLError(.badServerResponse)
        }
        return mockUsers
    }
}

@Suite(.serialized)

struct MainViewModelSwiftTestingTests {
    
    // MARK: - 1. Jeu de test autour de fetchUsers
    @Test("Les users sont bien chargés par la func fetchUsers")
    func testFetchUsersSuccess() async {
        
        let mock = MockUserListRepository()
        mock.mockUsers = sampleUsers
        
        let vm = MainViewModel(repository: mock)
        
        vm.fetchUsers()
        try? await Task.sleep(nanoseconds: 200_000_000) // petite attente
        
        #expect(vm.isLoading == false)
        #expect(vm.users.count == sampleUsers.count)
    }

    @Test("fetchUsers gère une erreur : users inchangés et isLoading = false")
    func testFetchUsersFailure() async {
        let mock = MockUserListRepository()
        mock.shouldReturnError = true    // crée dans le mock

        let vm = MainViewModel(repository: mock)
        vm.users = [sampleUser1]         // liste initiale

        vm.fetchUsers()
        try? await Task.sleep(nanoseconds: 200_000_000)

        #expect(vm.isLoading == false)
        #expect(vm.users == [sampleUser1])  // la liste ne change pas en cas d’erreur
    }
    
    // MARK: - 2. shouldLoadMoreData
    @Test("shouldLoadMoreData est true pour le dernier utilisateur")
    func testShouldLoadMoreDataLastItem() {
        
        let vm = MainViewModel(repository: MockUserListRepository())
        vm.users = [sampleUser1, sampleUser2]
        vm.isLoading = false
        
        #expect(vm.shouldLoadMoreData(currentItem: sampleUser2))
    }

    @Test("shouldLoadMoreData est false pour un item qui n'est pas le dernier")
    func testShouldLoadMoreDataNotLastItem() {
        let vm = MainViewModel(repository: MockUserListRepository())
        vm.users = [sampleUser1, sampleUser2]

        #expect(vm.shouldLoadMoreData(currentItem: sampleUser1) == false)
    }

    @Test("shouldLoadMoreData est false lorsque isLoading vaut true")
    func testShouldLoadMoreDataWhenLoading() {
        let vm = MainViewModel(repository: MockUserListRepository())
        vm.users = [sampleUser1, sampleUser2]
        vm.isLoading = true

        #expect(vm.shouldLoadMoreData(currentItem: sampleUser2) == false)
    }

    @Test("shouldLoadMoreData est false si la liste est vide")
    func testShouldLoadMoreDataEmptyList() {
        let vm = MainViewModel(repository: MockUserListRepository())
        vm.users = []

        #expect(vm.shouldLoadMoreData(currentItem: sampleUser1) == false)
    }

    // MARK: - 3. reloadUsers
    @Test("reloadUsers vide la liste, puis recharge une nouvelle liste")
    func testReloadUsers() async {
        let mock = MockUserListRepository()
        mock.mockUsers = [sampleUser1]
        
        let vm = MainViewModel(repository: mock)
        vm.users = [sampleUser2]
        
        await vm.reloadUsers()
        try? await Task.sleep(nanoseconds: 200_000_000)
        
        #expect(vm.users.count == 1)
        #expect(vm.users.first == sampleUser1)
    }
    
    @Test("reloadUsers gère une erreur : la liste reste vide et isLoading = false")
    func testReloadUsersFailure() async {
        let mock = MockUserListRepository()
        mock.shouldReturnError = true

        let vm = MainViewModel(repository: mock)
        vm.users = [sampleUser1]

        await vm.reloadUsers()
        try? await Task.sleep(nanoseconds: 200_000_000)

        #expect(vm.isLoading == false)
        #expect(vm.users.isEmpty)
    }
    
    @Test("reloadUsers vide la liste immédiatement et appelle bien fetchUsers")
    func testReloadUsersCoverage() async {

        // Mock spécial qui permet d'observer l'appel à fetchUsers()
        final class TrackingRepository: UserListRepository {
            var didCallFetchUsers = false
            
            override func fetchUsers(quantity: Int) async throws -> [User] {
                didCallFetchUsers = true
                return []   // on retourne une liste vide : ce n'est pas important pour ce test
            }
        }

        // On utilise notre repository qui trace l'appel
        let repo = TrackingRepository()
        let vm = MainViewModel(repository: repo)

        // On met des utilisateurs pour vérifier que reloadUsers() les supprime
        vm.users = [sampleUser1, sampleUser2]

        // --- WHEN ---
        await vm.reloadUsers()
        try? await Task.sleep(nanoseconds: 200_000_000)

        // --- THEN ---
        // Vérifie la 1ère ligne de reloadUsers()
        #expect(vm.users.isEmpty)

        // Vérifie la 2ème ligne : fetchUsers() a été appelée
        #expect(repo.didCallFetchUsers == true)
    }

        // MARK: - 4. Cycle de vie de isLoading
        @Test("fetchUsers déclenche isLoading = true puis false")
        func testFetchUsersLoadingCycle() async {
            let mock = MockUserListRepository()
            mock.mockUsers = sampleUsers

            let vm = MainViewModel(repository: mock)

            #expect(vm.isLoading == false)

            vm.fetchUsers()
            #expect(vm.isLoading == true)   // immédiatement après appel

            try? await Task.sleep(nanoseconds: 200_000_000)

            #expect(vm.isLoading == false) // après chargement
        }


        // MARK: - 5. Tests de l’état initial
        @Test("La ViewModel doit être initialisée avec isLoading = false et users = []")
        func testInitialState() {
            let vm = MainViewModel(repository: MockUserListRepository())

            #expect(vm.isLoading == false)
            #expect(vm.users.isEmpty)
        }
}

