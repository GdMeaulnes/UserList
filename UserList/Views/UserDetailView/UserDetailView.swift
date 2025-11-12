import SwiftUI

struct UserDetailView: View {
    let user: User
    
    var body: some View {
        // Un simple empilement de la photo, du nom et de l'âge
        VStack {
            AsyncImage(url: URL(string: user.picture.large)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
            } placeholder: {
                ProgressView()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
            }
            
            VStack(alignment: .leading) {
                    Text("\(user.dob.date) - \(user.dob.age) years")
                    .font(.subheadline)
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle("\(user.name.first) \(user.name.last)")
    }
}

struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailView(user: sampleUser1)
    }
}
