import Foundation

class SearchViewModel {
    var searchResult: [WeatherInfo]? {
        didSet {
            self.reloadUI()
        }
    }
    
    var reloadUI: () -> Void = {}
    
    func searching(text: String) {
        print(text)
        // Make API call
        let weatherService = WeatherService()

        weatherService.getWeatherInfo(with: text) { result in
            switch result {
            case .success(let weatherInfo):
                // Populate searchResultList variable
                self.searchResult = [weatherInfo]
                print("Temperature: \(weatherInfo.main.temp) K")
            case .failure(let error):
                // Handle the error
                print("Error fetching weather information: \(error.localizedDescription)")
            }
        }
    }
}
