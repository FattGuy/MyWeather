import Foundation
import CoreLocation

class WeatherService {
    
    let networkManager: NetworkProtocol
    
    init(networkManager: NetworkProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getWeatherInfo(with currentLocation: CLLocationCoordinate2D, completion: @escaping (Result<WeatherInfo, Error>) -> Void) {
        // Create a URLRequest for the API endpoint
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            completion(.failure(NetworkError.invalidURLComponent))
            return
        }
        let apiKey = AppConstants.OpenWeather.apiKey
        let lat = "\(currentLocation.latitude)"
        let lon = "\(currentLocation.longitude)"
        
        urlComponents.queryItems = [
            URLQueryItem(name: "lat", value: lat),
            URLQueryItem(name: "lon", value: lon),
            URLQueryItem(name: "appid", value: apiKey)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Call the networkManager's performRequest method to make the API request
        networkManager.performRequest(request, decodeType: WeatherInfo.self) { result in
            switch result {
            case .success(let weatherInfo):
                completion(.success(weatherInfo))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
