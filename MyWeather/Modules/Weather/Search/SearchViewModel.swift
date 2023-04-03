import Foundation
import CoreLocation

class SearchViewModel: LocationHelperDelegate {
    private let locationHelper = LocationHelper()
    var currentLocation: CLLocation? {
        didSet {
            self.fetchCurrentLocationWeather()
        }
    }
    
    var searchResult: [WeatherInfo] = [] {
        didSet {
            self.reloadUI()
        }
    }
    
    var reloadUI: () -> Void = {}
    
    init() {
        locationHelper.delegate = self
    }
    
    func searching(text: String) {
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
        
        weatherService.getWeatherInfo(from: text) { result in
            switch result {
            case .success(let weatherInfo):
                // Populate searchResultList variable
                if !self.searchResult.contains(where: { $0.name == weatherInfo.name }) {
                    self.searchResult.append(weatherInfo)
                }
            case .failure(let error):
                // Handle the error
                print("Error fetching weather information: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchCurrentLocationWeather() {
        // Make API call
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self] // Set up mock URL protocol
        let urlSession = URLSession(configuration: configuration)
        let networkManager = NetworkManager(session: urlSession)
        let weatherService = WeatherService(networkManager: networkManager)
        
        guard let mockURL = Bundle.main.url(forResource: "CurrentWeatherInfo", withExtension: "json"),
              let mockData = try? Data(contentsOf: mockURL) else {
            fatalError("Failed to load mock data from file")
        }
        
        MockURLProtocol.mockResponseData = mockData
        
        guard let coords = currentLocation?.coordinate else {
            print("Current location does not exist")
            return
        }
        weatherService.getWeatherInfo(at: coords) { result in
            switch result {
            case .success(let weatherInfo):
                // Populate searchResultList variable
                self.searchResult = [weatherInfo]
            case .failure(let error):
                // Handle the error
                print("Error fetching weather information: \(error.localizedDescription)")
            }
        }
    }
    
    func didUpdateLocation(_ location: CLLocation) {
        currentLocation = location
    }
}
