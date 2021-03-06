//
//  TodayViewController.swift
//  WeatherTest
//
//  Created by Daniel Kouba on 14/02/15.
//  Copyright (c) 2015 Daniel Kouba. All rights reserved.
//

import UIKit
import Foundation

class TodayViewController: UIViewController {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var rainChanceLabel: UILabel!
    @IBOutlet weak var rainAmmountLabel: UILabel!
    @IBOutlet weak var tempreatureLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    @IBOutlet weak var shareLabel: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var isCurrentIcon: UIImageView!
    
    var location = DI.context.locations.selectedLocation
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Today"
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "populate", name: RELOAD_NOTIFICATION, object: nil)
        populate()
        animateView()
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func populate() {
        location = DI.context.locations.selectedLocation
        var weather = location.weather
        weather.fetchWeather()
        iconImageView.image = weather.iconImageBig
        locationLabel.text = location.getTitle()
        summaryLabel.text = weather.summary()
        isCurrentIcon.hidden = !location.isCurrent
        
        rainChanceLabel.text = weather.rainPercentage
        rainAmmountLabel.text = weather.rainAmmount()
        tempreatureLabel.text = weather.tempreature(false)
        windSpeedLabel.text = weather.windSpeed()
        windDirectionLabel.text = weather.windDirection
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSwipeRight(sender: AnyObject) {
        if let tbc = tabBarController as? TabBarController {
            tbc.prevTab()
        }
    }
    @IBAction func onSwipeLeft(sender: AnyObject) {
        if let tbc = tabBarController as? TabBarController {
            tbc.nextTab()
        }
    }
    
    @IBAction func onSwipeUp()
    {
        if DI.context.locations.selectNextLocation() {
            animateViewFast(1)
        }
    }
    
    @IBAction func onSwipeDown()
    {
        if DI.context.locations.selectPrevLocation() {
            animateViewFast(-1)
        }
    }
    
    @IBAction func sharePressed(sender: AnyObject) {
        NSLog("Not implemented yet")
        
        var url = NSURL(string: "http://www.danielkouba.cz")!
        var text = "Weather Test App for STRV"
       
        var activityVC = UIActivityViewController(activityItems: [text, url], applicationActivities: nil)
        navigationController?.presentViewController(activityVC, animated: true, completion: { () -> Void in            
            
        })
        
    }
    
    
    func animateView()
    {
        containerView.layer.transform =  CATransform3DMakeRotation(2, 1, -1, 0)
        containerView.layer.transform.m34 = 1.0 / 2500
        containerView.alpha = 0
        
        iconImageView.layer.transform = CATransform3DMakeTranslation(0, -250, 0)
        locationLabel.layer.transform =  CATransform3DMakeTranslation(-250, 0, 0)
        summaryLabel.layer.transform =  CATransform3DMakeTranslation(250, 0, 0)
        shareLabel.layer.transform =  CATransform3DMakeTranslation(0, 250, 0)
        detailView.layer.transform = CATransform3DMakeTranslation(0, 50, 0)
        
        
        UIView.beginAnimations("today", context: nil)
        UIView.setAnimationDuration(1.0)
        
        iconImageView.layer.transform = CATransform3DIdentity
        locationLabel.layer.transform =  CATransform3DIdentity
        summaryLabel.layer.transform =  CATransform3DIdentity
        shareLabel.layer.transform =  CATransform3DIdentity
        detailView.layer.transform = CATransform3DIdentity
        
        containerView.layer.transform = CATransform3DIdentity
        containerView.alpha = 1
        
        UIView.commitAnimations()
    }
    
    func animateViewFast(direction: CGFloat)
    {

        containerView.layer.transform = CATransform3DMakeTranslation(0, (direction * containerView.frame.height)/1.5, 0)
        containerView.alpha = 0
       
        iconImageView.layer.transform =  CATransform3DMakeRotation(2 , 1,0, 0)
        iconImageView.layer.transform.m34 = 1.0 / 2500
        
        
        UIView.beginAnimations("today", context: nil)
        UIView.setAnimationDuration(0.5)
        
        iconImageView.layer.transform = CATransform3DIdentity
        containerView.layer.transform = CATransform3DIdentity
        containerView.alpha = 1
        
        UIView.commitAnimations()
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
