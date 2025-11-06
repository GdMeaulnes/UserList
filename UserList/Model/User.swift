import Foundation

struct User: Identifiable {
    var id = UUID()
    let name: Name
    let dob: Dob
    let picture: Picture

    // MARK: - Init
    init(user: UserListResponse.User) {
        self.name = .init(title: user.name.title, first: user.name.first, last: user.name.last)
        self.dob = .init(date: user.dob.date, age: user.dob.age)
        self.picture = .init(large: user.picture.large, medium: user.picture.medium, thumbnail: user.picture.thumbnail)
    }

    // MARK: - Dob
    struct Dob: Codable {
        let date: String
        let age: Int
    }

    // MARK: - Name
    struct Name: Codable {
        let title, first, last: String
    }

    // MARK: - Picture
    struct Picture: Codable {
        let large, medium, thumbnail: String
    }
}

// Samples users

let sampleUser1: User = .init(
    user: .init(
        name: .init(title: "Mrs", first: "White", last: "Swown"),
        dob: .init(date: "2024-09-14", age: 43),
        picture: .init(large: "https://randomuser.me/api/portraits/men/3.jpg", medium: "https://randomuser.me/api/portraits/med/men/3.jpg", thumbnail: "https://randomuser.me/api/portraits/thumb/men/3.jpg")
    )
)

let sampleUser2: User = .init(
    user: .init(
        name: .init(title: "Mrs", first: "Lydia", last: "Powers"),
        dob: .init(date: "1984-09-14", age: 38),
        picture: .init(large: "https://randomuser.me/api/portraits/women/3.jpg", medium: "https://randomuser.me/api/portraits/med/women/3.jpg", thumbnail: "https://randomuser.me/api/portraits/thumb/women/3.jpg")
    )
)

let sampleUser3: User = .init(
    user: .init(
        name: .init(title: "Mrs", first: "Moi", last: "Moi"),
        dob: .init(date: "1984-09-14", age: 62),
        picture: .init(large: "https://randomuser.me/api/portraits/women/5.jpg", medium: "https://randomuser.me/api/portraits/med/women/5.jpg", thumbnail: "https://randomuser.me/api/portraits/thumb/women/5.jpg")
    )
)

let sampleUser4: User = .init(
    user: .init(
        name: .init(title: "Mrs", first: "Lui", last: "Lui"),
        dob: .init(date: "1884-09-14", age: 162),
        picture: .init(large: "https://randomuser.me/api/portraits/men/5.jpg", medium: "https://randomuser.me/api/portraits/med/men/5.jpg", thumbnail: "https://randomuser.me/api/portraits/thumb/men/5.jpg")
    )
)

let sampleUsers = [sampleUser1, sampleUser2, sampleUser3, sampleUser4, sampleUser1, sampleUser2, sampleUser3, sampleUser1, sampleUser2, sampleUser3]
