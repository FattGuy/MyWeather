import UIKit

class WeatherDetailViewController: UIViewController {
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var feelsLikeText: UILabel!
    @IBOutlet weak var temperatureText: UILabel!
    @IBOutlet weak var weatherStatusLabel: UILabel!
    
    var viewModel = WeatherDetailViewModel()
    var coordinator: RootCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setCoordinates(with info: WeatherInfo) {
        self.viewModel.delegate = self
        self.viewModel.coords = info.coord
    }
}

extension WeatherDetailViewController: WeatherDetailViewModelDelegate {
    func weatherLoaded() {
        guard let weather = viewModel.weatherData else { return }
        self.cityLabel.text = weather.name
        
//        self.weatherIcon.sd_setImage(
//            with: getImageFor(name: weather.weather?.first?.icon ?? "01d"),
//            completed: nil)
////        self.weatherIcon.image = viewModel.weatherIcon
//        self.weatherTitle.text = weather.weather?.first?.main
//        self.weatherSubtitle.text = weather.weather?.first?.description
//        guard let temperature = weather.main?.temp,
//              let feelsLike = weather.main?.feelsLike else { return }
//        self.temperatureText.text = String(describing: temperature) + " °C"
//        self.feelsLikeText.text = "Feels like " + String(describing: feelsLike) + " °C"
        
    }
    
    private func getImageFor(name: String) -> URL {
        let urlString = "https://openweathermap.org/img/wn/*@2x.png"
            .replacingOccurrences(of: "*", with: name)
        return URL(string: urlString)!
    }
    
}
