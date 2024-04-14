import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var weatherLabel: UILabel!
    
    let apiKey = "YOUR_API_KEY"
    let weatherAPIURL = "https://api.openweathermap.org/data/2.5/weather"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure text field
        cityTextField.placeholder = "Enter city name"
    }
    
    // MARK: - IBActions
    
    @IBAction func checkWeatherButtonTapped(_ sender: UIButton) {
        guard let city = cityTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !city.isEmpty else {
            showAlert(message: "Please enter a city name.")
            return
        }
        
        fetchWeather(for: city)
    }
    
    // MARK: - Helper Methods
    
    func fetchWeather(for city: String) {
        let urlString = "\(weatherAPIURL)?q=\(city)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else {
            showAlert(message: "Invalid URL.")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                self.showAlert(message: "Error fetching weather data: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                self.showAlert(message: "No data received.")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(WeatherData.self, from: data)
                DispatchQueue.main.async {
                    self.weatherLabel.text = "Temperature: \(weatherData.main.temp)°C, Description: \(weatherData.weather[0].description)"
                }
            } catch {
                self.showAlert(message: "Error decoding weather data: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

struct WeatherData: Codable {
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
}

