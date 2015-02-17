//
//  SettingsViewController.swift
//  WeatherTest
//
//  Created by Daniel Kouba on 14/02/15.
//  Copyright (c) 2015 Daniel Kouba. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var context = DI.context
    var settings: Settings?
    var options = [
        SettingOptions.LengthUnit,
        SettingOptions.TempreatureUnit
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.tableFooterView = UIView(frame: CGRectMake(0, 0, context.screenSize().width, 1))
        tableView.tableFooterView?.backgroundColor = UIColor(red: 0, green:0, blue: 0, alpha: 0.1)
        
        settings = context.settings
        
      
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Settings"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation
//    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if ( segue.identifier == "settingOption") {
//            var settingOptionVC = segue.destinationViewController as UITableViewController
//            settingOptionVC.tableView.delegate = settings
//            settingOptionVC.tableView.dataSource = settings
//            settingOptionVC.tableView.tableFooterView = UIView(frame: CGRectMake(0, 0, context.screenSize().width, 1))
//            settingOptionVC.tableView.tableFooterView?.backgroundColor = UIColor.lightGrayColor()
//            
//            settings?.optionSelectedHandler = {
//                settingOptionVC.performSegueWithIdentifier("tabbar", sender: nil)
//                return
//            }
//        }
//    }
    
    //MARK: UITableView
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.whiteColor();
        header.textLabel.textColor = tableView.tintColor;
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "GENERAL"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("setting") as UITableViewCell
        var valueLabel = cell.viewWithTag(1)! as UILabel
        var option: SettingOptions = options[indexPath.item];
        
        cell.textLabel!.text = option.rawValue
        valueLabel.text = settings?.getSettingForKey(option)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        settings?.scope = options[indexPath.item]
        
        var settingOptionVC = UITableViewController()
        settingOptionVC.tableView.delegate = settings
        settingOptionVC.tableView.dataSource = settings
        settingOptionVC.tableView.tableFooterView = UIView(frame: CGRectMake(0, 0, context.screenSize().width, 1))
        settingOptionVC.tableView.tableFooterView?.backgroundColor = UIColor.lightGrayColor()
        self.navigationController?.pushViewController(settingOptionVC, animated: true)
        
        settings?.optionSelectedHandler = {
            self.navigationController?.popViewControllerAnimated(true)
            return
        }
        
        
    }
    
    
}
