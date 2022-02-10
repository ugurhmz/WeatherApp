//
//  HourlyTableViewCell.swift
//  WeatherApp
//
//  Created by ugur-pc on 10.02.2022.
//

import UIKit

class HourlyTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    static let identifier = "HourlyTableViewCell"
    
    
    static func nib() -> UINib {
        return UINib(nibName: "HourlyTableViewCell",
                     bundle: nil)
    }
    
}
