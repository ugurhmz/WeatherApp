
//  Location : CoreLocation
//  tableView
//  custom cell: collection view
//  API / get datas.


import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet var tableView : UITableView!
    var weatherModels = [DailyWeatherEntry]()
    
    // location
    let locationManager = CLLocationManager()
    var currentLocation : CLLocation?
    
    
    var current : CurrentWeather?
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        // Full-with bg
        tableView.backgroundColor = UIColor(red: 35/255.0,
                                            green: 130/255.0,
                                            blue: 180/255.0,
                                            alpha: 1.0)
        
        view.backgroundColor = UIColor(red: 35/255.0,
                                       green: 130/255.0,
                                       blue: 180/255.0,
                                       alpha: 1.0)
        
        
        // register
        tableView.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
        tableView.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
    }
    
    
    
    // Location
    func setupLocation(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }
    
    
    func requestWeatherForLocation(){
        
        guard let currentLocation = currentLocation else {
            return
        }

        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        
        
        let url  = "https://api.darksky.net/forecast/ddcc4ebb2a7c9930b90d9e59bda0ba7a/\(lat),\(long)?exclude=[flags,minutely]"
        
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
                
            // Validation
            guard let data = data,  error == nil else {
                print("ERROR!")
                return
            }
            
            
            // Convert data to models
            var json : WeatherResponse? // Api'den gelen ilk key'lerin structunu veriyoruz.
            
            do {
                
                // GET JSON DATAS
                json = try JSONDecoder().decode(WeatherResponse.self, from: data)
                
            } catch {
                print("parsing error!", error)
            }
            
            
            guard let result = json else {
                return
            }
            
           
            self.weatherModels.append(contentsOf: result.daily.data)
        
            
            let current = result.currently
            self.current = current
            
            // Update UI
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.tableHeaderView = self.createTableHeader()
            }
            
            
            
        }).resume()
        
    }
    
    
    
    // TOP Header section
    func createTableHeader () -> UIView {
        let headerView = UIView(frame:CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width-20))
   
        
        headerView.backgroundColor = UIColor(red: 35/255.0,
                                             green: 130/255.0,
                                             blue: 180/255.0,
                                             alpha: 1.0)
        
    
        
        
        let locationLabel = UILabel(frame: CGRect(x: 10,
                                                  y: 10,
                                                  width: view.frame.size.width-20,
                                                  height: headerView.frame.size.height/5))
        
        let summaryLabel = UILabel(frame: CGRect(x: 10,
                                                 y: 20+locationLabel.frame.size.height,
                                                 width: view.frame.size.width-20,
                                                 height: headerView.frame.size.height/5))
        
        let tempLabel =  UILabel(frame: CGRect(x: 10,
                                               y: 12+locationLabel.frame.size.height+summaryLabel.frame.size.height,
                                               width: view.frame.size.width-20,
                                               height: headerView.frame.size.height/2))
        
        headerView.addSubview(locationLabel)
        headerView.addSubview(tempLabel)
        headerView.addSubview(summaryLabel)
        
        
        tempLabel.textAlignment = .center
        summaryLabel.textAlignment = .center
        locationLabel.textAlignment = .center
        
        
        guard let currentWeather = self.current else {
            return UIView()
        }

        
        
        
        // Text set
        locationLabel.text = "Current loc"
        locationLabel.textColor = .white
        locationLabel.font = UIFont(name : "Helvetica", size:25)
        
        
        summaryLabel.text = "\(currentWeather.summary)"
        summaryLabel.textColor = .white
        summaryLabel.font = UIFont(name : "Helvetica", size:25)
        
        tempLabel.text = String(format: "%.1f °C", ((currentWeather.temperature - 32 ) * (5/9)))
        tempLabel.font = UIFont(name : "Helvetica-Bold", size: 32)
        tempLabel.textColor = .orange
        
        return headerView
        
    }
    
    
    
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherModels.count
    }
    
    
    
    
    // cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
            cell.configure(with: weatherModels[indexPath.row])
        
        // cell-bg
        cell.backgroundColor = UIColor(red: 35/255.0,
                                       green: 130/255.0,
                                       blue: 175/255.0,
                                       alpha: 0.9)
        
        return cell
    }
    
    // heightForRowAt   -> O Rowun yüksekliği
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    

}



//  MODEL


//      API  -    first come keys.
struct WeatherResponse: Codable {
    let latitude: Float
    let longitude: Float
    let timezone: String
    let currently: CurrentWeather     //  Nesne olduğu için bir başka structu veriyoruz.
    let hourly: HourlyWeather        //  Nesne olduğu için bir başka structu veriyoruz. object {}
    let daily: DailyWeather          //  object {}
    let offset: Float
}




// CurrentWeather       currently : {......}
struct CurrentWeather: Codable {
    let time: Int
    let summary: String
    let icon: String
    let nearestStormDistance: Int
    let nearestStormBearing: Int
    let precipIntensity: Int
    let precipProbability: Int
    let temperature: Double
    let apparentTemperature: Double
    let dewPoint: Double
    let humidity: Double
    let pressure: Double
    let windSpeed: Double
    let windGust: Double
    let windBearing: Int
    let cloudCover: Double
    let uvIndex: Int
    let visibility: Double
    let ozone: Double
}




// DailyWeather
struct DailyWeather: Codable {
    let summary: String
    let icon: String
    let data: [DailyWeatherEntry]       // data arrayi
}





// DailyWeatherEntry  ,    Arrayin field'ları.
struct DailyWeatherEntry: Codable {
    let time: Int
    let summary: String
    let icon: String
    let sunriseTime: Int
    let sunsetTime: Int
    let moonPhase: Double
    let precipIntensity: Float
    let precipIntensityMax: Float
    let precipIntensityMaxTime: Int?
    let precipProbability: Double
    let precipType: String?
    let temperatureHigh: Double
    let temperatureHighTime: Int
    let temperatureLow: Double
    let temperatureLowTime: Int
    let apparentTemperatureHigh: Double
    let apparentTemperatureHighTime: Int
    let apparentTemperatureLow: Double
    let apparentTemperatureLowTime: Int
    let dewPoint: Double
    let humidity: Double
    let pressure: Double
    let windSpeed: Double
    let windGust: Double
    let windGustTime: Int
    let windBearing: Int
    let cloudCover: Double
    let uvIndex: Int
    let uvIndexTime: Int
    let visibility: Double
    let ozone: Double

    let temperatureMin: Double
    let temperatureMinTime: Int
    let temperatureMax: Double
    let temperatureMaxTime: Int
    let apparentTemperatureMin: Double
    let apparentTemperatureMinTime: Int
    let apparentTemperatureMax: Double
    let apparentTemperatureMaxTime: Int
}



// HourlyWeather
struct HourlyWeather: Codable {
    let summary: String
    let icon: String
    let data: [HourlyWeatherEntry]
}





// HourlyWeatherEntry
struct HourlyWeatherEntry: Codable {
    let time: Int
    let summary: String
    let icon: String
    let precipIntensity: Float
    let precipProbability: Double
    let precipType: String?
    let temperature: Double
    let apparentTemperature: Double
    let dewPoint: Double
    let humidity: Double
    let pressure: Double
    let windSpeed: Double
    let windGust: Double
    let windBearing: Int
    let cloudCover: Double
    let uvIndex: Int
    let visibility: Double
    let ozone: Double
}
