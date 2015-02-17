//
//  NavigationController.swift
//  WeatherTest
//
//  Created by Daniel Kouba on 15/02/15.
//  Copyright (c) 2015 Daniel Kouba. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func styleBar() {
        
        var bar = self.navigationBar
        bar.frame.size.height += 1
        
        
//        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "Line_settings"), forBarMetrics: UIBarMetrics.Default)
        
        UINavigationBar.appearance().shadowImage = UIImage()
        var navBorder = UIView(frame: CGRectMake(0, bar.frame.size.height-1, bar.frame.size.width, 1) )
        navBorder.addSubview(UIImageView(image:  UIImage(named: "Line_settings")) )
        self.navigationBar.addSubview(navBorder)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
