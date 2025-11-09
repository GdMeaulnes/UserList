import Foundation

// Exemple d'utilisation
//let url = URL(string: "https://api.example.com/users")!
//let request = try URLRequest(
//    url: url,
//    method: .POST,
//    parameters: ["name": "Alice", "age": 30],
//    headers: ["Authorization": "Bearer 12345"]

extension URLRequest {
    init(
        url: URL,
        method: HTTPMethod,
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil
    ) throws {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw URLError(.badURL)
        }
//        Ici, on ajoute un initialiseur personnalisé à URLRequest :
//            •    url : l’adresse cible.
//            •    method : une énumération (probablement définie ailleurs) de type HTTPMethod (ex. .GET, .POST).
//            •    parameters : dictionnaire optionnel de paramètres.
//            •    headers : dictionnaire optionnel d’en-têtes HTTP.
//
//        Il peut jeter une erreur (throws) si l’URL est invalide ou si la sérialisation JSON échoue.
        
//        On crée un objet URLComponents à partir de l’URL.
//        Cela permet de manipuler facilement les paramètres de requête (?key=value).
//
//        Si la création échoue, on lance une erreur URLError(.badURL).
        
        
        self.init(url: url) //on initialise la requête standard.

        httpMethod = method.rawValue //on assigne la méthode HTTP ("GET", "POST", etc.), obtenue via method.rawValue.

        if let parameters = parameters {
            switch method {
            case .GET:
                encodeParametersInURL(parameters, components: components) //Si des paramètres existent, pour une requête GET, ils sont ajoutés à l’URL (ex. ?user=John&id=42).
            case .POST:
                try encodeParametersInBody(parameters) //Si des paramètres existent, pour une requête POST, ils sont placés dans le corps (httpBody) au format JSON.
            }
        }

        if let headers = headers {
            for (key, value) in headers {
                setValue(value, forHTTPHeaderField: key) // Si des en-têtes sont fournis, ils sont ajoutés à la requête : (ex. "Authorization": "Bearer token", "Accept": "application/json").
            }
        }
    }

    // Méthode privée – GET
    private mutating func encodeParametersInURL(
        _ parameters: [String: Any],
        components: URLComponents
    ) {
        var components = components
        components.queryItems = parameters
            .map { ($0, "\($1)") }
            .map { URLQueryItem(name: $0, value: $1) }
        url = components.url
    }
//    •    On crée une copie mutable de components.
//    •    On transforme chaque paire clé/valeur du dictionnaire en URLQueryItem.
//    •    On recompose l’URL finale avec ces paramètres.
//
//Exemple :
//Si parameters = ["name": "Alice", "age": 30],
//l’URL devient :
//https://example.com?name=Alice&age=30

    
    // Méthode privée – POST
    private mutating func encodeParametersInBody(
        _ parameters: [String: Any]
    ) throws {
        setValue("application/json", forHTTPHeaderField: "Content-Type")
        httpBody = try JSONSerialization.data(
            withJSONObject: parameters,
            options: .prettyPrinted
        )
    }
//    •    Définit le header "Content-Type" à "application/json".
//    •    Sérialise le dictionnaire parameters en données JSON et les place dans le corps (httpBody).
//
//Exemple :
//["name": "Alice", "age": 30] devient :
//    {
//      "name" : "Alice",
//      "age" : 30
//    }
    
}
