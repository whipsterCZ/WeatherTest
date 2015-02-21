//
// Dependency Injection Container
//  Created by Daniel Kouba on 29/12/14.
//  Copyright (c) 2014 Daniel Kouba. All rights reserved.
//

import Foundation
import UIKit
import CoreData

let FONT_REGULAR = "Proxima Nova"
let FONT_BOLD = "Proxima Nova-Bold"
let FONT_SEMIBOLD = "ProximaNova-Semibold" //Proč nefunguje název s Mezerou???
let FONT_LIGHT = "Proxima Nova-Light"

let RELOAD_NOTIFICATION = "reloadData"

class DI : NSObject {
    
    //MARK: Dependency Injection
    
    //Get SystemContainer | Context  - singleton
    class var context : DI {
        struct Static {
            static let instance = DI()
        }
        return Static.instance
    }
    
    
    func getParameter(key:String, defaultValue:String? = nil) -> String? {
        if let param = config.objectForKey(key) as? String {
            return param
        }
        return defaultValue;
    }
    
    lazy var config : NSDictionary = {
        return NSDictionary(
            contentsOfFile: NSBundle.mainBundle().pathForResource("config", ofType: "plist")!
            )!
        }()
    
    //MARK: - Services
    lazy var settings = Settings()
    
    lazy var locations: Locations = {
        return Locations(
            apiUrl: DI.context.getParameter("search_api_url")!,
            apiKey: DI.context.getParameter("weather_api_key")!
        )
    }()
    
    
    lazy var weatherService: WeatherService = {
        return WeatherService(
            apiUrl: DI.context.getParameter("weather_api_url")!,
            apiKey: DI.context.getParameter("weather_api_key")!
        )        
    }()
    
    lazy var lightBlue = UIColor(red: 95/255, green: 140/255, blue: 1, alpha: 1)
    lazy var darkGray = UIColor(white: 0.2, alpha: 1)
    
    func animateTableCell(cell:UITableViewCell) {
        
        cell.layer.transform =  CATransform3DMakeRotation(3.14/2, -1, 0, 0)
        cell.layer.transform.m34 = 1.0 / 1500
        cell.layer.backgroundColor = UIColor(white: 0.99, alpha: 0.5).CGColor
        
        UIView.beginAnimations("rotation", context: nil)
        UIView.setAnimationDuration(0.5)
        cell.layer.transform = CATransform3DIdentity;
        cell.layer.backgroundColor = UIColor.whiteColor().CGColor
        UIView.commitAnimations()
        
    }
    
    func animateTableCell3DRotation(cell:UITableViewCell) {
        
        cell.layer.transform = CATransform3DRotate(CATransform3DMakeRotation(-1, 1, 0, 0), 1, -1, 1, 0)
        cell.alpha = 0;
        
        //Define the final state (After the animation) and commit the animation
        UIView.beginAnimations("rotation", context: nil)
        UIView.setAnimationDuration(0.5)
        cell.layer.transform = CATransform3DIdentity;
        cell.alpha = 1;
        UIView.commitAnimations()
    }
    
    
    //MARK: - Convenience
    
    func application() -> UIApplication
    {
        return UIApplication.sharedApplication()
    }
    
    func appDelegate() -> AppDelegate? {
        return application().delegate as AppDelegate?
    }
    
    func viewController() -> UIViewController?
    {
        return application().keyWindow?.rootViewController
    }
    
    func screenSize() -> CGSize
    {
        return UIScreen.mainScreen().bounds.size
    }
    
    func storyBoard() -> UIStoryboard
    {
        return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    }
       
    
    
}