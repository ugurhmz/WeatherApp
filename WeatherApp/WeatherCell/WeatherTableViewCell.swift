

import UIKit

class WeatherTableViewCell: UITableViewCell {

    
    @IBOutlet var dayLabel     : UILabel!
    @IBOutlet var highTempLabel : UILabel!
    @IBOutlet var lowTempLabel : UILabel!
    @IBOutlet var iconImgView  : UIImageView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .secondarySystemBackground
        
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
        self.lowTempLabel.text = "\(Int((model.temperatureLow - 32)*(5/9)))°C"
        self.highTempLabel.text = "\(Int((model.temperatureHigh - 32)*(5/9)))°C"
        self.dayLabel.text = getDateForDate(Date(timeIntervalSince1970: Double(model.time)))
        self.iconImgView.image = UIImage(named:  "sun")
    }
    
    
    
    func getDateForDate(_ date: Date?) -> String {
        guard let  inputDate = date else {
            return "-"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        
        return formatter.string(from: inputDate)
    }
    
    
    
    
    
}
