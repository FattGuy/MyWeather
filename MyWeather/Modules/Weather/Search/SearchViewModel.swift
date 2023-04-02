import Foundation

class SearchViewModel {
    var searchResult: [WeatherInfo]? {
        didSet {
            self.reloadUI()
        }
    }
    
    var reloadUI: () -> Void = {}
    
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
                self.searchResult = [weatherInfo]
            case .failure(let error):
                // Handle the error
                print("Error fetching weather information: \(error.localizedDescription)")
            }
        }
    }
}
