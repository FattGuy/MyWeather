import UIKit
import SDWebImage

class WeatherDetailViewController: UIViewController {
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherStatusLabel: UILabel!
    
    var viewModel = WeatherDetailViewModel()
    var coordinator: RootCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.weatherLoaded()
    }
    
    func setCoordinates(with info: WeatherInfo) {
        self.viewModel.coords = info.coord
    }
    
    func weatherLoaded() {
        guard let weather = viewModel.weatherData else { return }
        self.cityLabel.text = weather.name
        self.weatherIcon.sd_setImage(
            with: getImageFor(name: weather.weather.first?.icon ?? "01d"),
            completed: nil)
        self.temperatureLabel.text = "\(weather.main.temp) °C"
        self.feelsLikeLabel.text = "\(weather.main.feelsLike) °C"
        self.weatherStatusLabel.text = weather.weather.first?.description ?? "Unknown weather status"
        
    }
    
    private func getImageFor(name: String) -> URL {
        let urlString = "https://openweathermap.org/img/wn/*@2x.png"
            .replacingOccurrences(of: "*", with: name)
        return URL(string: urlString)!
    }
}
