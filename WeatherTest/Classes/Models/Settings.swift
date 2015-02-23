//
//  Settings.swift
//  WeatherTest
//
//  Created by Daniel Kouba on 14/02/15.
//  Copyright (c) 2015 Daniel Kouba. All rights reserved.
//

import Foundation
import UIKit


enum LengthUnit: String {
    case Metric = "Metric"
    case Imperial = "Imperial"
}

enum TempreatureUnit: String {
    case Celsius = "Celsius"
    case Fahrenheit = "Fahrenheit"
}

enum SettingOptions: String
{
    case LengthUnit = "Unit of length"
    case TempreatureUnit = "Unit of tempreature"
}

class Settings: NSObject, UITableViewDataSource, UITableViewDelegate
{
    
    var tempreatureUnit:TempreatureUnit?
    var lengthUnit: LengthUnit?
    
    var scope = SettingOptions.TempreatureUnit
    var tempreatureUnitOptions = [ TempreatureUnit.Celsius, TempreatureUnit.Fahrenheit ]
    var lengthUnitOptions = [ LengthUnit.Metric, LengthUnit.Imperial ]
    var optionSelectedHandler: (()->Void)?
    
    private let userDefaults: NSUserDefaults
    
    override init () {
        self.userDefaults = NSUserDefaults.standardUserDefaults()
        super.init()
        
        NSLog("init settings")
        loadState()        
        
    }
    
    func getSettingForKey(key: SettingOptions) -> String
    {
        switch key {
        case .LengthUnit:       return self.lengthUnit!.rawValue
        case .TempreatureUnit:  return self.tempreatureUnit!.rawValue
        }
    }
    
    func setSettingForKey(key: SettingOptions, value: String)
    {
        switch key {
        case .LengthUnit:       self.lengthUnit = LengthUnit(rawValue: value)
        case .TempreatureUnit:  self.tempreatureUnit = TempreatureUnit(rawValue: value)
        }
    }
    
    func loadState() {
    
        if let savedTempreatureUnit = userDefaults.stringForKey(SettingOptions.TempreatureUnit.rawValue) {
            tempreatureUnit = TempreatureUnit(rawValue: savedTempreatureUnit )!
        } else {
            var defaultValue = DI.context.getParameter("default_tempreature_unit", defaultValue: "Celsius")!
            tempreatureUnit = TempreatureUnit(rawValue: defaultValue)!
        }
        
        if let savedLengthUnit = userDefaults.stringForKey(SettingOptions.LengthUnit.rawValue) {
             lengthUnit = LengthUnit(rawValue: savedLengthUnit)!
        } else {
            var defaultValue = DI.context.getParameter("default_length_unit", defaultValue: "Metric")!
            lengthUnit = LengthUnit(rawValue: defaultValue)!
        }
    }
    
    func saveState() {
        
        userDefaults.setValue(tempreatureUnit?.rawValue, forKey: SettingOptions.TempreatureUnit.rawValue)
        userDefaults.setValue(lengthUnit?.rawValue, forKey: SettingOptions.LengthUnit.rawValue)
        userDefaults.synchronize();
//        NSNotificationCenter.defaultCenter().postNotificationName(RELOAD_NOTIFICATION, object: nil)
        
    }
    
    // Particular Setting View Controller
    //MARK: UITableViewDelegate protocol
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch scope {
        case .LengthUnit:       setSettingForKey(scope, value: lengthUnitOptions[indexPath.item].rawValue)
        case .TempreatureUnit:  setSettingForKey(scope, value: tempreatureUnitOptions[indexPath.item].rawValue)
        }
        optionSelectedHandler!()
        
    }

    
    //MARK: UITableViewDatasource protocol
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        switch scope {
        case .LengthUnit:       cell.textLabel!.text = lengthUnitOptions[indexPath.item].rawValue
        case .TempreatureUnit:  cell.textLabel!.text = tempreatureUnitOptions[indexPath.item].rawValue
        }
        cell.textLabel?.font = UIFont(name: FONT_REGULAR, size: 17)
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch scope {
        case .LengthUnit:       return countElements(lengthUnitOptions)
        case .TempreatureUnit:  return countElements(tempreatureUnitOptions)
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return scope.rawValue
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50;
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.whiteColor();
        header.textLabel.textColor = tableView.tintColor;
        header.textLabel.font = UIFont(name: FONT_SEMIBOLD, size: 14)
        
        let headerSize = header.bounds.size
        
        let image = UIImage(named: "Line_forecast")
        let border = UIImageView(image: image)
        border.frame = CGRectMake(0, headerSize.height-1, headerSize.width, 1)
        header.addSubview(border)
        
    }
    
}