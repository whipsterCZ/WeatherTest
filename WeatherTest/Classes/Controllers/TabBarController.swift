//
//  TabBarController.swift
//  WeatherTest
//
//  Created by Daniel Kouba on 15/02/15.
//  Copyright (c) 2015 Daniel Kouba. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    @IBOutlet var locationButton: UIBarButtonItem!
    var locations = DI.context.locations
    var settings = DI.context.settings

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        if ( item.title == "Settings") {
            self.navigationItem.rightBarButtonItem = nil
        } else {
            if ( self.navigationItem.rightBarButtonItem == nil ) {
                self.navigationItem.rightBarButtonItem = locationButton
            }
        }
    }
    
   

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
//        if ( segue.destinationViewController)
        
    }
    
    func showLocationVC(sender:AnyObject)
    {
        
        self.performSegueWithIdentifier("locations", sender: sender)
        
    }
    

}
