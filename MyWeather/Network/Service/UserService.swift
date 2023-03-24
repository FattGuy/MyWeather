import Foundation

class UserService {
    
    let networkManager: NetworkProtocol
    
    init(networkManager: NetworkProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getUserInfo(userId: String, completion: @escaping (Result<User, Error>) -> Void) {
        // Create a URLRequest for the API endpoint
        guard let url = URL(string: "https://example.com/users/\(userId)") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Call the networkManager's performRequest method to make the API request
        networkManager.performRequest(request, decodeType: User.self) { result in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

