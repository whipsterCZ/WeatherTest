//
//  AddLocationViewController.swift
//  WeatherTest
//
//  Created by Daniel Kouba on 14/02/15.
//  Copyright (c) 2015 Daniel Kouba. All rights reserved.
//

import UIKit

class AddLocationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,  UISearchDisplayDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var locations = DI.context.locations
    var locationList = [LocationData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.hidden = true
    
        //Hack for hidding empty cells
        tableView.tableFooterView = UIView()
        
        //SearchBar styling - see also SearchBar.swft
        UISearchBar.appearance().setImage(UIImage(named: "Search"), forSearchBarIcon: .Search, state: .Normal)
        UISearchBar.appearance().setImage(UIImage(named: "Close"), forSearchBarIcon: .Clear, state: .Normal)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func searchLocations(search:String) {
        locations.searchLocations(search, limit: 10, success: { (foundLocations) -> Void in
            self.locationList = foundLocations
            self.searchDisplayController?.searchResultsTableView.reloadData()
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == self.tableView {
            return 0
        } else {
            return locationList.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("locationCell") as? UITableViewCell
        if ( cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "locationCell")
        }
        
        if tableView == self.tableView {
            cell!.textLabel?.text = ""
        } else {
            cell!.textLabel?.text = locationList[indexPath.item].getTitle()
        }
        
        
        return cell!
    }
    
    //MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var place = ""
        if tableView == self.searchDisplayController?.searchResultsTableView {
            var location = locationList[indexPath.item]
            locations.addLocationToList(location)
            performSegueWithIdentifier("locationAdded", sender: self)

        }
    }
    
    
    //MARK: - UISearchBarDelegate
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        performSegueWithIdentifier("locationAdded", sender: self)
    }
    
    //MARK: - UISearchDisplayDelegate
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool
    {
        searchLocations(searchString)
        return true
    }
    
    var searchTableViewHasOffset = false
    func searchDisplayController(controller: UISearchDisplayController, willShowSearchResultsTableView tableView: UITableView) {
        if !searchTableViewHasOffset {
            tableView.frame.origin.y += 2
            tableView.frame.size.height -= 2
            searchTableViewHasOffset = true
        }
    }
    
    
    
    
    
   
    
    
}
