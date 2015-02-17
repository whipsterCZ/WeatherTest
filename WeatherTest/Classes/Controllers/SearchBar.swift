//
//  SearchBar.swift
//  WeatherTest
//
//  Created by Daniel Kouba on 15/02/15.
//  Copyright (c) 2015 Daniel Kouba. All rights reserved.
//

import UIKit

class SearchBar: UISearchBar {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func layoutSubviews() {
    
        self.setBackgroundImage(UIImage(), forBarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)
        
        for view in self.subviews[0].subviews {
//            println(view.description)
            if let textEdit = view as? UITextField {
                
                var color = DI.context.lightBlue
                
                textEdit.borderStyle = UITextBorderStyle.None
                textEdit.layer.cornerRadius = 5
                textEdit.layer.borderWidth = 1
                textEdit.layer.borderColor = color.CGColor
                textEdit.layer.masksToBounds = true
                
                textEdit.textColor = color
                textEdit.tintColor = color
            }

            
//            if let textEdit = view as? UINavigationButton {
//                
//            }
        }
            
        super.layoutSubviews()
    }

}
