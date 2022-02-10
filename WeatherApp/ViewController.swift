


//  Location : CoreLocation
//  tableView
//  custom cell: collection view
//  API / get datas.





import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet var tableView : UITableView!
    var weatherModels = [Weather]()
    
    // location
    let locationManager = CLLocationManager()
    var currentLocation : CLLocation?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
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
            
            
            
            // Update UI
            
        })
        
    }
    
    
    
    
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherModels.count
    }
    
    
    
    
    // cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    

}



//  MODEL

// API  -    first come keys.
struct WeatherResponse  : Codable {
    let latitude    : Float
    let longiuted   : Float
    let timezone    : String
    let currently   : CurrentlyWeather   //  Nesne olduğu için bir başka structu veriyoruz.
    let hourly      : HourlyWeather     // Bir başka struct, çünkü gelen data object {}
    let daily       : DailyWeather     //  Object {}
    let offset      : Float
}


// API - contents of object currently {....}
struct CurrentlyWeather : Codable {
    let time    : Int
    let summary : String
    let icon    : String
    let nearestStormDistance : Int
    let precipIntensity      : Int
    let precipProbability    : Int
    let temperature          : Double
    let apparentTemperature  : Double
    let dewPoint    : Double
    let humidity    : Double
    let pressure    : Int
    let windSpeed   : Double
    let windGust    : Double
    let windBearing : Int
    let cloudCover  : Double
    let uvIndex     : Int
    let visibility  : Int
    let ozone       : Double
    
}

// Hourly
struct HourlyWeather : Codable {
    let summary : String
    let icon    : String
    let data    : [HourlyWeatherEntry]  // data is array
    
}


// HourlyEntry
struct HourlyWeatherEntry : Codable {
    let time                 : Int
    let summary              : String
    let icon                 : String
    let precipIntensity      : Int
    let precipProbability    : Int
    let temperature          : Double
    let apparentTemperature  : Double
    let dewPoint    : Double
    let humidity    : Double
    let pressure    : Int
    let windSpeed   : Double
    let windGust    : Double
    let windBearing : Int
    let cloudCover  : Double
    let uvIndex     : Int
    let visibility  : Int
    let ozone       : Double
}



// Daily
struct DailyWeather : Codable {
    let summary : String
    let icon    : String
    let data    : [DailyWeatherEntry]  // data is array.
    
}


// DailyEntery
struct DailyWeatherEntry : Codable {
    let time                 : Int
    let summary              : String
    let icon                 : String
    let sunriseTime          : Int
    let sunrisetTime         : Int
    let moonPhase            : Double
    let precipIntensity      : Int
    let precipProbability    : Int
    let temperatureHigh      : Double
    let temperatureHighTime  : Int
    let temperatureLow       : Double
    let temperatureLowTime   : Int
    let apparentTemperatureHigh       : Double
    let apparentTemperatureHighTime   : Int
    let apparentTemperatureLow        : Double
    let apparentTemperatureLowTime    : Int
    let dewPoint    : Double
    let humidity    : Double
    let pressure    : Double
    let windSpeed   : Double
    let windGust    : Double
    let windBearing : Int
    let cloudCover  : Double
    let uvIndex     : Int
    let uvIndexTime : Int
    let visibility  : Int
    let ozone       : Double
    let temperatureMin              : Double
    let temperatureMinTime          : Int
    let temperatureMax              : Int
    let temperatureMaxTime          : Double
    let apparentTemperatureMin      : Double
    let apparentTemperatureMinTime  : Int
    let apparentTemperatureMax      : Double
    let apparentTemperatureMaxTime  : Int
}
