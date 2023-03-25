struct RainStatus: Codable {
    var oneHour: Double
    
    private enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
    }
}
