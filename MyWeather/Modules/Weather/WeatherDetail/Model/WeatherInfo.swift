struct WeatherInfo: Codable {
    var coord: Coordinates
    var weather: [WeatherType]
    var base: String
    var main: WeatherStats
    var visibility: Int
    var wind: WindStatus
    var rain: RainStatus
    var clouds: CloudsStatus
    var name: String
}
