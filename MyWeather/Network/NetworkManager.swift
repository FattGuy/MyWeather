import Foundation

protocol NetworkProtocol {
    func performRequest<T: Decodable>(_ request: URLRequest, decodeType: T.Type, completion: @escaping (Result<T, Error>) -> Void)
}

enum NetworkError: Error {
    case invalidURL
    case invalidURLComponent
    case invalidResponse
    case noData
}

class NetworkManager: NetworkProtocol {
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func performRequest<T: Decodable>(_ request: URLRequest, decodeType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(decodeType, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
