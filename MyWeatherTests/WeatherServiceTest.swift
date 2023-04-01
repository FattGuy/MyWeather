import XCTest
import CoreLocation

final class WeatherServiceTest: XCTestCase {
    
    var weatherService: WeatherService!
    var expectation: XCTestExpectation!
    
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
                },
                "name": "Current"
            }
            """
        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail("Failed to convert JSON string to Data")
            return
        }
        
        MockURLProtocol.mockResponseData = jsonData
        
        let coordinate2D = CLLocationCoordinate2D(latitude: 44.34, longitude: 10.99)
        weatherService.getWeatherInfo(at: coordinate2D) { result in
            switch result {
            case .success(let weatherInfo):
                XCTAssertEqual(weatherInfo.coord.lon, 10.99, "Incorrect lat.")
                XCTAssertEqual(weatherInfo.coord.lat, 44.34, "Incorrect lon.")
                XCTAssertEqual(weatherInfo.weather.first?.main, "Rain", "Incorrect main.")
                XCTAssertEqual(weatherInfo.weather.first?.id, 501, "Incorrect id.")
                XCTAssertEqual(weatherInfo.weather.first?.description, "moderate rain", "Incorrect description.")
                XCTAssertEqual(weatherInfo.weather.first?.icon, "10d", "Incorrect icon.")
                XCTAssertEqual(weatherInfo.base, "stations", "Incorrect userID.")
                XCTAssertEqual(weatherInfo.main.temp, 298.48, "Incorrect temp.")
                XCTAssertEqual(weatherInfo.main.feelsLike, 298.74, "Incorrect feelsLike.")
                XCTAssertEqual(weatherInfo.main.tempMin, 297.56, "Incorrect tempMin.")
                XCTAssertEqual(weatherInfo.main.tempMax, 300.05, "Incorrect tempMax.")
                XCTAssertEqual(weatherInfo.main.pressure, 1015, "Incorrect pressure.")
                XCTAssertEqual(weatherInfo.main.humidity, 64, "Incorrect humidity.")
                XCTAssertEqual(weatherInfo.main.seaLevel, 1015, "Incorrect seaLevel.")
                XCTAssertEqual(weatherInfo.main.grndLevel, 933, "Incorrect grndLevel.")
                XCTAssertEqual(weatherInfo.visibility, 10000, "Incorrect visibility.")
                XCTAssertEqual(weatherInfo.wind.speed, 0.62, "Incorrect wind speed.")
                XCTAssertEqual(weatherInfo.wind.deg, 349, "Incorrect wind deg.")
                XCTAssertEqual(weatherInfo.wind.gust, 1.18, "Incorrect wind gust.")
                XCTAssertEqual(weatherInfo.rain.oneHour, 3.16, "Incorrect rain oneHour.")
                XCTAssertEqual(weatherInfo.clouds.all, 100, "Incorrect clouds all.")
                XCTAssertEqual(weatherInfo.name, "Current", "Incorrect city name.")
            case .failure(let error):
                XCTFail("Unexpected error: \(error.localizedDescription)")
            }
            self.expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}
