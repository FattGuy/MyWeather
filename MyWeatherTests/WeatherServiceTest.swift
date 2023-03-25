import XCTest
import CoreLocation

final class WeatherServiceTest: XCTestCase {
    
    var weatherService: WeatherService!
    var expectation: XCTestExpectation!
    let apiURL = URL(string: "https://jsonplaceholder.typicode.com/posts/")
    
    override func setUp() {
        super.setUp()
        
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self] // Set up mock URL protocol
        let urlSession = URLSession(configuration: configuration)
        let networkManager = NetworkManager(session: urlSession)
        
        weatherService = WeatherService(networkManager: networkManager)
        expectation = expectation(description: "Expectation")
    }
    
    func testGetWeatherInfo() {
        // Set up mock response data
        let jsonString = """
            {
                "coord": {
                    "lon": 10.99,
                    "lat": 44.34
                },
                "weather": [{
                    "id": 501,
                    "main": "Rain",
                    "description": "moderate rain",
                    "icon": "10d"
                }],
                "base": "stations",
                "main": {
                    "temp": 298.48,
                    "feels_like": 298.74,
                    "temp_min": 297.56,
                    "temp_max": 300.05,
                    "pressure": 1015,
                    "humidity": 64,
                    "sea_level": 1015,
                    "grnd_level": 933
                },
                "visibility": 10000,
                "wind": {
                    "speed": 0.62,
                    "deg": 349,
                    "gust": 1.18
                },
                "rain": {
                    "1h": 3.16
                },
                "clouds": {
                    "all": 100
                }
            }
            """
        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail("Failed to convert JSON string to Data")
            return
        }
        
        MockURLProtocol.mockResponseData = jsonData
        
        let coordinate2D = CLLocationCoordinate2D(latitude: 44.34, longitude: 10.99)
        weatherService.getWeatherInfo(with: coordinate2D) { result in
            switch result {
            case .success(let weather):
                XCTAssertEqual(weather.base, "stations", "Incorrect userID.")
            case .failure(let error):
                XCTFail("Unexpected error: \(error.localizedDescription)")
            }
            self.expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}
