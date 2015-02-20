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
    @IBOutlet weak var border: UIImageView!
    
    var locations = DI.context.locations
    var locationList = [Location]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(LocationSearchCell.self, forCellReuseIdentifier: "searchCell")
        self.searchDisplayController?.searchResultsTableView.registerClass(LocationSearchCell.self, forCellReuseIdentifier: "searchCell")
        
        //Hack for hidding empty cells
        tableView.tableFooterView = UIView()
        
        //SearchBar styling - see also SearchBar.swft
        UISearchBar.appearance().setImage(UIImage(named: "Search"), forSearchBarIcon: .Search, state: .Normal)
        UISearchBar.appearance().setImage(UIImage(named: "Close"), forSearchBarIcon: .Clear, state: .Normal)
        
        //set border line scaling
        border.contentMode = UIViewContentMode.ScaleToFill
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
         self.navigationController?.navigationBar.hidden = true
    }
    
    
    
    func searchLocations(search:String) {
        locations.searchLocations(search, limit: 10, success: { (foundLocations) -> Void in
            self.locationList = foundLocations
            self.searchDisplayController?.searchResultsTableView.reloadData()
        })
    }
    
    func navigateToLocations() {
        self.dismissViewControllerAnimated(true, completion: nil)
//        self.navigationController?.popViewControllerAnimated(true)
//        performSegueWithIdentifier("locationAdded", sender: self)
    }
    
    func markSearchedText(search: String, found: String) -> String
    {
        if ( search.isEmpty) {
            return found
        }
        let mutableString = NSMutableString(string: found)
        let regular = NSRegularExpression(pattern:search, options: NSRegularExpressionOptions.CaseInsensitive, error: nil)
        
        regular!.replaceMatchesInString(
            mutableString,
            options: NSMatchingOptions.allZeros,
            range: NSRange(location: 0, length: mutableString.length) ,
            withTemplate: "<b>"+search+"</b>"
        )
        return mutableString as String
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
        var cell = tableView.dequeueReusableCellWithIdentifier("searchCell", forIndexPath: indexPath) as LocationSearchCell
        
        if tableView == self.tableView {
            cell.label?.text = "text"
        } else {
            var text = locationList[indexPath.item].getTitle()
            text = markSearchedText(searchBar.text, found: text)
            cell.label?.text = text
        }
 
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var place = ""
        if tableView == self.searchDisplayController?.searchResultsTableView {
            var location = locationList[indexPath.item]
            locations.addLocationToList(location)
            navigateToLocations()

        }
    }
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        //Cell animation
        cell.layer.transform = CATransform3DMakeTranslation( -cell.frame.width/3, -cell.frame.origin.y, 0)
        cell.alpha = 0;
        
        //Define the final state (After the animation) and commit the animation
        UIView.beginAnimations("rotation", context: nil)
        UIView.setAnimationDuration(0.5)
        cell.layer.transform = CATransform3DIdentity;
        cell.alpha = 1;
        UIView.commitAnimations()
        
    }
    
    //MARK: - UISearchBarDelegate
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        navigateToLocations()
    }
    
    //MARK: - UISearchDisplayDelegate
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool
    {
        searchLocations(searchString)
        return true
    }
    
    //add color line under search
    var searchTableViewHasOffset = false
    func searchDisplayController(controller: UISearchDisplayController, willShowSearchResultsTableView tableView: UITableView) {
        if !searchTableViewHasOffset {
            tableView.frame.origin.y += 2
            tableView.frame.size.height -= 2
            searchTableViewHasOffset = true
        }
    }
    
    
    
    
    
   
    
    
}
