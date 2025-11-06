import SwiftUI

struct UserListView: View {
    
    // One bunch of users
    let users: [User]
    
    var body: some View {
        
//        NavigationStack {
            List(users) { user in
                NavigationLink(destination: UserDetailView(user: user)) {
                    HStack {
                        AsyncImage(url: URL(string: user.picture.thumbnail)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        } placeholder: {
                            ProgressView()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        }
                        VStack(alignment: .leading) {
                            Text("\(user.name.first) \(user.name.last)")
                                .font(.headline)
                            
                            Text("\(user.dob.date) - \(user.dob.age) years")
                                .font(.subheadline)
                        }
                    }
                }
                .navigationTitle("Users - List Mode")
            }
//        }
    }
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView(users: sampleUsers)
    }
}
