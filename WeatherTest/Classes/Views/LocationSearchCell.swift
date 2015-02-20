//
//  LocationSearchCell.swift
//  WeatherTest
//
//  Created by Daniel Kouba on 17/02/15.
//  Copyright (c) 2015 Daniel Kouba. All rights reserved.
//

import UIKit

class LocationSearchCell: UITableViewCell {
    
    var label: RTLabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        var size = self.contentView.frame.size
        
        label = RTLabel(frame: CGRectMake(28, 16, size.width-28.0, size.height-16.0))
        label!.font = UIFont(name: FONT_REGULAR, size: 16)
        label!.textColor = DI.context.darkGray
        label?.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        label?.textAlignment = RTTextAlignmentLeft
        
        addSubview(label!)        

    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
