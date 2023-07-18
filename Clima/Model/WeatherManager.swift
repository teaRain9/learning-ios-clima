import Foundation

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=516b85aa69eac6a8f93fb0b70c9798be&units=metric"
    
    func fetchWeather(cityName: String) {
        let urlSring = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlSring)
    }
    
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    parseJSON(weatherData: safeData)
                }
                
            }
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            print(weather.conditionName)
            print(weather.temperatureString)
        } catch {
            print(error)
            
        }
    }
}
