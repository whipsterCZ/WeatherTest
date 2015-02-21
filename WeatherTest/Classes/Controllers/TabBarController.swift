//
//  TabBarController.swift
//  WeatherTest
//
//  Created by Daniel Kouba on 15/02/15.
//  Copyright (c) 2015 Daniel Kouba. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController , UITabBarControllerDelegate {
    
    @IBOutlet var locationButton: UIBarButtonItem!
    var locations = DI.context.locations
    var settings = DI.context.settings

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
    }
    
   
    
    // MARK: - Navigation

    func nextTab()
    {
        if let itemCount = tabBar.items?.count {
            selectedIndex = (selectedIndex+1) % itemCount
        }
    }
    
    func prevTab()
    {
        if let itemCount = tabBar.items?.count {
            let index = selectedIndex==0 ? itemCount : selectedIndex
            selectedIndex = (index-1) % itemCount
        }
        
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }
    
    func showLocationVC(sender:AnyObject)
    {
        self.performSegueWithIdentifier("locations", sender: sender)        
    }
    
    
    //MARK: - UITabBarControllerDelegate
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        if ( viewController is SettingsViewController ) {
            self.navigationItem.rightBarButtonItem = nil
        } else {
            if ( self.navigationItem.rightBarButtonItem == nil ) {
                self.navigationItem.rightBarButtonItem = locationButton
            }
        }
        
    }
    
    

}
