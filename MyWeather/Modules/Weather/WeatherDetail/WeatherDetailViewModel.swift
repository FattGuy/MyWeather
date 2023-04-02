import Foundation
import CoreLocation

protocol WeatherDetailViewModelDelegate {
    func weatherLoaded()
}

class WeatherDetailViewModel {
    
    var delegate: WeatherDetailViewModelDelegate?
    var weatherData: WeatherInfo?
    var coords: Coordinates? {
        didSet {
            self.fetchWeather()
        }
    }
    
    func fetchWeather() {
        // Make API call
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self] // Set up mock URL protocol
        let urlSession = URLSession(configuration: configuration)
        let networkManager = NetworkManager(session: urlSession)
        let weatherService = WeatherService(networkManager: networkManager)
        
        guard let mockURL = Bundle.main.url(forResource: "LondonWeatherInfo", withExtension: "json"),
              let mockData = try? Data(contentsOf: mockURL) else {
            fatalError("Failed to load mock data from file")
        }
        
        MockURLProtocol.mockResponseData = mockData
        
        let coord = CLLocationCoordinate2D(latitude: coords?.lat ?? 0.0, longitude: coords?.lon ?? 0.0)
        weatherService.getWeatherInfo(at: coord) { result in
            switch result {
            case .success(let weatherInfo):
                self.weatherData = weatherInfo
            case .failure(let error):
                print("Unexpected error: \(error.localizedDescription)")
            }
        }
    }
}
