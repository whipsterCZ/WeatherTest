//
//  LocationsViewController.swift
//  WeatherTest
//
//  Created by Daniel Kouba on 15/02/15.
//  Copyright (c) 2015 Daniel Kouba. All rights reserved.
//

import UIKit
import CoreData

class LocationsViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var locations = DI.context.locations
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib(nibName: "WeatherCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "weatherCell")
        
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "donePressed:")

    }
    
    override func viewWillAppear(animated: Bool) {
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadData", name: RELOAD_NOTIFICATION, object: nil)
        self.navigationController?.navigationBar.hidden = false
        reloadData()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.locationList.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier("weatherCell") as WeatherCell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: WeatherCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        //set Cell content
        var location = locations.locationList[indexPath.item]
        cell.titleLabel.text =  location.city
        cell.weatherLabel.text = location.weather.type
        cell.icon.image = location.weather.iconImage
        cell.isCurrentIcon.hidden = !location.isCurrent
        cell.tempreatureLabel.text = location.weather.tempreature(true)
        
        //Cell animation
        cell.layer.transform = CATransform3DMakeScale( 0.5, 0, 0.5)
        cell.alpha = 0;
        
        //Define the final state (After the animation) and commit the animation
        UIView.beginAnimations("rotation", context: nil)
        UIView.setAnimationDuration(0.5)
        cell.layer.transform = CATransform3DIdentity;
        cell.alpha = 1;
        UIView.commitAnimations()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }

    
    //MARK: - UITableViewDelegate

    // Override to support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//            
//            DI.context.managedObjectContext!.deleteObject(locations.locationList[indexPath.item])
//            locations.locationList.removeAtIndex(indexPath.item)
//            tableView.reloadData()
//        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        var action = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "  X   ") { (action, indexPath) -> Void in            
            self.locations.locationList.removeAtIndex(indexPath.item)
            self.locations.saveState()
        }
        action.backgroundColor = UIColor(red: 228, green: 141/255, blue: 73/255, alpha: 1)
        
        return [action]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        locations.selectedLocation = locations.locationList[indexPath.item]
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }

    
    
    /*
    // Override to support rearranging the table view.
    func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    
    func donePressed(sender:AnyObject? ) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    

}
