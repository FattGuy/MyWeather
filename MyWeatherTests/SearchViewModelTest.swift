import XCTest
import CoreLocation

class SearchViewModelTests: XCTestCase {
    
    var viewModel: SearchViewModel!
    var mockService: MockURLProtocol!
    var location: CLLocation!
    
    override func setUp() {
        super.setUp()
        
        viewModel = SearchViewModel()
        
        // Set up a mock location
        location = CLLocation(latitude: 37.7749, longitude: -122.4194)
        viewModel.currentLocation = location
    }
    
    func testSearchingWithEmptyText() {
        // Given
        let mockWeather = WeatherInfo(
            coord: Coordinates(lon: -0.1276, lat: 51.5072),
            weather: [
                WeatherType(id: 800, main: "Clear", description: "clear sky", icon: "01d")
            ],
            base: "stations",
            main: WeatherStats(
                temp: 20.0,
                feelsLike: 18.0,
                tempMin: 18.0,
                tempMax: 22.0,
                pressure: 1020,
                humidity: 40,
                seaLevel: 100,
                grndLevel: 10000
            ),
            visibility: 10000,
            wind: WindStatus(
                speed: 3.6,
                deg: 160, gust: 4.15
            ),
            rain: RainStatus(
                oneHour: 0.0
            ),
            clouds: CloudsStatus(
                all: 0
            ),
            name: "Current"
        )
        viewModel.searchResult = [mockWeather]
        
        // When
        viewModel.searching(text: "")
        
        // Then
        XCTAssertEqual(viewModel.searchResult.count, 1)
        XCTAssertEqual(viewModel.searchResult.first?.name, "Current")
    }
    
    func testSearchingWithNonEmptyText() {
        // Given
        let mockWeather = WeatherInfo(
            coord: Coordinates(lon: -0.1276, lat: 51.5072),
            weather: [
                WeatherType(id: 800, main: "Clear", description: "clear sky", icon: "01d")
            ],
            base: "stations",
            main: WeatherStats(
                temp: 20.0,
                feelsLike: 18.0,
                tempMin: 18.0,
                tempMax: 22.0,
                pressure: 1020,
                humidity: 40,
                seaLevel: 100,
                grndLevel: 10000
            ),
            visibility: 10000,
            wind: WindStatus(
                speed: 3.6,
                deg: 160, gust: 4.15
            ),
            rain: RainStatus(
                oneHour: 0.0
            ),
            clouds: CloudsStatus(
                all: 0
            ),
            name: "London"
        )
        viewModel.searchResult = [mockWeather]
        // When
        viewModel.searching(text: "London")
        
        // Then
        XCTAssertEqual(viewModel.searchResult.count, 1)
        XCTAssertEqual(viewModel.searchResult.first?.name, "London")
    }
    
    func testDidUpdateLocation() {
        // Given
        let newLocation = CLLocation(latitude: 51.5072, longitude: -0.1276)
        
        // When
        viewModel.didUpdateLocation(newLocation)
        
        // Then
        XCTAssertEqual(viewModel.currentLocation?.coordinate.latitude, newLocation.coordinate.latitude)
        XCTAssertEqual(viewModel.currentLocation?.coordinate.longitude, newLocation.coordinate.longitude)
    }
}
