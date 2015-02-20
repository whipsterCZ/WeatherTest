//
//  WeatherCell.swift
//  WeatherTest
//
//  Created by Daniel Kouba on 18/02/15.
//  Copyright (c) 2015 Daniel Kouba. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var tempreatureLabel: UILabel!
    @IBOutlet weak var isCurrentIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        isCurrentIcon.hidden = true
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
