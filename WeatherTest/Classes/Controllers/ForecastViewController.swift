//
//  ForecastViewController.swift
//  WeatherTest
//
//  Created by Daniel Kouba on 14/02/15.
//  Copyright (c) 2015 Daniel Kouba. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController, UITableViewDataSource , UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var forecastList = [Forecast]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(UINib(nibName: "WeatherCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "weatherCell")
        tableView.allowsSelection = false

    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadData", name: RELOAD_NOTIFICATION, object: nil)
        reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func reloadData() {
        forecastList = DI.context.locations.selectedLocation.weather.forecastList
        self.navigationController?.navigationBar.topItem?.title = DI.context.locations.selectedLocation.city
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("weatherCell") as WeatherCell!
        return cell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastList.count*3
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: WeatherCell, forRowAtIndexPath indexPath: NSIndexPath) {
        var index = indexPath.item % forecastList.count
        var day = forecastList[index]
        
        cell.titleLabel.text = day.weekday
        cell.tempreatureLabel.text = day.tempreature(true)
        cell.icon.image = DI.context.locations.selectedLocation.weather.iconImage
        cell.weatherLabel.text = DI.context.locations.selectedLocation.weather.type
     
        
        //Cell animation
        cell.layer.transform = CATransform3DRotate(CATransform3DMakeRotation(-1, 1, 0, 0), 1, -1, 1, 0)
        cell.alpha = 0;
        
        //Define the final state (After the animation) and commit the animation
        UIView.beginAnimations("rotation", context: nil)
        UIView.setAnimationDuration(0.5)
        cell.layer.transform = CATransform3DIdentity;
        cell.alpha = 1;
        UIView.commitAnimations()
    }

}
