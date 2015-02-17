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
        
        
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "donePressed:")

    }
    
    override func viewDidAppear(animated: Bool) {
        locations.TableViewForReload = self.tableView
    }
    
    override func viewWillDisappear(animated: Bool) {
        locations.TableViewForReload = self.tableView
        DI.context.managedObjectContext!.save(nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return locations.locationList.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("locationCell", forIndexPath: indexPath) as UITableViewCell

        cell.textLabel?.text = locations.locationList[indexPath.item].city

        return cell
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
        
        var action = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "X") { (action, indexPath) -> Void in
            DI.context.managedObjectContext!.deleteObject(self.locations.locationList[indexPath.item])
            self.locations.locationList.removeAtIndex(indexPath.item)
            self.tableView.reloadData()
        }
        action.backgroundColor = UIColor(red: 228, green: 141/255, blue: 73/255, alpha: 1)
        
        return [action]
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
