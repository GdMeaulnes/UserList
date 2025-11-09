import Foundation

//Un repository (ou dépôt) est une couche d’accès aux données.
//Son rôle : récupérer les données (ici, des utilisateurs) depuis une source externe — en l’occurrence, une API HTTP.
struct UserListRepository {

    // C’est une fonction stockée (une closure). Elle prend en entrée une URLRequest et renvoie un couple (Data, URLResponse) de manière asynchrone et pouvant lever une erreur (async throws).
    //executeDataRequest est une fonction qui exécute une requête réseau et retourne la réponse.
    private let executeDataRequest: (URLRequest) async throws -> (Data, URLResponse)


    // @escaping : le closure peut être conservé et appelé plus tard. Le paramètre a une valeur par défaut : URLSession.shared.data(for:), qui est la méthode standard de Swift pour effectuer une requête réseau avec async/await.
    //
    // Par défaut, le repository utilise URLSession.shared pour faire ses appels HTTP. Mais on peut injecter une autre fonction (par exemple pour les tests unitaires).
    init(
        executeDataRequest: @escaping (URLRequest) async throws -> (Data, URLResponse) = URLSession.shared.data(for:)
    ) {
        self.executeDataRequest = executeDataRequest
    }
    
    // Fonction principale de recup asynchrone (async) car elle effectue un appel réseau, peut lever des erreurs (throws) et retourne un tableau de User.
    func fetchUsers(quantity: Int) async throws -> [User] {

//      On crée l’URL de l’API publique randomuser.me (qui génère des utilisateurs aléatoires). Si elle échoue, on lance une erreur URLError(.badURL).
        guard let url = URL(string: "https://randomuser.me/api/") else {
            throw URLError(.badURL)
        }

        // Contruction de l'URL en GET qui donne https://randomuser.me/api/?results=20
        let request = try URLRequest(
            url: url,
            method: .GET,
            parameters: [
                "results": quantity
            ]
        )

        // On exécute la requête via la fonction executeDataRequest, qui est, par défaut, URLSession.shared.data(for:).
        // On attend la réponse (await) et on récupère : data (le corps de la réponse HTTP) et la réponse HTTP elle-même (non utilisée ici).
        let (data, _) = try await executeDataRequest(request)

        // On décode le Data reçu (JSON) en une structure UserListResponse.
        let response = try JSONDecoder().decode(UserListResponse.self, from: data)
        
        // On transforme les éléments décodés (UserResponse) en véritables objets User du modèle métier.
        return response.results.map(User.init)
    }
}
