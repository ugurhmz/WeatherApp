
import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {

    
    static let identifier = "WeatherCollectionViewCell"
    
    
    static func nib() -> UINib {
        return UINib(nibName: "WeatherCollectionViewCell",
                     bundle: nil)
        
    }
    
    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var tempLabel:  UILabel!
    
    // configure
    func configure(with model: HourlyWeatherEntry) {
        self.tempLabel.text = String(format: "%.1f °C", ((model.temperature - 32 ) * (5/9)))
        self.iconImageView.contentMode = .scaleAspectFit
        
        let icon = model.icon.lowercased()
        
        if icon.contains("clear") {
            self.iconImageView.image = UIImage(named:"clear-day")
            
        } else if icon.contains("rain") {
            self.iconImageView.image = UIImage(named: "rain")
            
        } else if icon.contains("partly-cloudy-day"){
            self.iconImageView.image = UIImage(named: "partly-cloudy-day")
        } else {
            self.iconImageView.image = UIImage(named: "cloud")
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
