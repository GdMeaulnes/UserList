//
//  UserDetailViewSwiftTestingTests.swift
//  UserList
//
//  Created by Richard DOUXAMI on 07/12/2025.
//

import SwiftUI
import Testing
@testable import UserList

@Suite("UserDetailViewSwiftTestingTests")
struct UserDetailViewTests {
    
    @Test("L'init de la View ne plante pas")
    func userDetailView_canBeInitialized() {
        
        let view = UserDetailView(user: sampleUser1)
        
        #expect(view.user.name.first == "White")
        #expect(view.user.name.last == "Swown")
    }
    
    @Test("Le body de la View peut être généré sans problème")
    func userDetailView_bodyCanBeEvaluated() {
           
        let view = UserDetailView(user: sampleUser1)
        
        let _ = view.body
        
        #expect(true)
    }
}
