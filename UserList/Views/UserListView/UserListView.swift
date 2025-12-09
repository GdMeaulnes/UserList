import SwiftUI

struct UserListView: View {
    
    @EnvironmentObject var viewModel: MainViewModel
    
    var body: some View {
        
        List(viewModel.users) { user in
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
                // Lorsque la dernière vue est affichée, on charge à la suite un paquet de plus
                .onAppear {
                    if viewModel.shouldLoadMoreData(currentItem: user) {
                        viewModel.fetchUsers()
                    }
                }
                .navigationTitle("Users - List Mode")
            }
    }
}


struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserListView()
                .environmentObject(MainViewModel.preview)
        }
    }
}
