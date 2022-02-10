

import UIKit

class WeatherTableViewCell: UITableViewCell {

    
    @IBOutlet var dayLabel     : UILabel!
    @IBOutlet var highTempLabel : UILabel!
    @IBOutlet var lowTempLabel : UILabel!
    @IBOutlet var iconImgView  : UIImageView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    static let identifier = "WeatherTableViewCell"
    
    
    static func nib() -> UINib {
        return UINib(nibName: "WeatherTableViewCell",
                     bundle: nil)
    }
    
    
    
    // configure
    func configure(with model: DailyWeatherEntry) {
        
        // text-align
        self.lowTempLabel.textAlignment = .center
        self.highTempLabel.textAlignment = .center
        
        
        // text
        self.lowTempLabel.text = "\(Int((model.temperatureLow - 32)*(5/9)))°C"
        self.highTempLabel.text = "\(Int((model.temperatureHigh - 32)*(5/9)))°C"
        self.dayLabel.text = getDateForDate(Date(timeIntervalSince1970: Double(model.time)))
        self.dayLabel.font = UIFont(name : "Helvetica-Bold", size: 21)
        self.iconImgView.contentMode = .scaleAspectFit
       
        
        let icon = model.icon.lowercased()
        
        if icon.contains("clear") {
            self.iconImgView.image = UIImage(named:"clear-day")
            
        } else if icon.contains("rain") {
            self.iconImgView.image = UIImage(named: "rain")
            
        } else if icon.contains("partly-cloudy-day"){
            self.iconImgView.image = UIImage(named: "partly-cloudy-day")
        } else {
            self.iconImgView.image = UIImage(named: "cloud")
        }
        
         
        
    }
    
    
    
    func getDateForDate(_ date: Date?) -> String {
        guard let  inputDate = date else {
            return "-"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        
        return formatter.string(from: inputDate)
    }
    
    
    
    
    
}
