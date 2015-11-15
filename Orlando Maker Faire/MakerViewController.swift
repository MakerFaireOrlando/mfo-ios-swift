//
//  MakerViewController.swift
//  Orlando Maker Faire
//
//  Created by Conner Brooks on 6/9/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

import UIKit

class MakerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MakerAPIProtocol, UISearchBarDelegate, UISearchResultsUpdating {

    let kCellIdentifier: String = "MakerCell"

    
    @IBOutlet var makerTableView : UITableView!
    
    var api: MakerAPI?
    var projects: [Project] = []
    var searchResults: [Project] = []
    var resultSearchController = UISearchController()
    var refreshControl:UIRefreshControl!
    
    let indicator:UIActivityIndicatorView = UIActivityIndicatorView  (activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.api = MakerAPI(delegate: self)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.api!.getMakers()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.tintColor = UIColor.redColor()
        //self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.makerTableView.addSubview(refreshControl)
        
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.hidesNavigationBarDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            self.makerTableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        indicator.color = UIColor.redColor()
        indicator.frame = CGRectMake(0.0, 0.0, 36.0, 36.0)
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        indicator.bringSubviewToFront(self.view)
        indicator.startAnimating()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refresh(sender:AnyObject)
    {
        self.api!.getMakers()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        searchResults.removeAll(keepCapacity: false)
        
        let searchPredicate = NSPredicate(format: "project_name CONTAINS[c] %@", searchController.searchBar.text)
        let array = (projects as NSArray).filteredArrayUsingPredicate(searchPredicate)
        searchResults = array as! [Project]
        
        self.makerTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.resultSearchController.active) {
            return self.searchResults.count
        }
        else {
            return self.projects.count
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as! UITableViewCell
    
        if (self.resultSearchController.active) {
            let maker = self.searchResults[indexPath.row]
            cell.textLabel!.text = maker.project_name
            cell.detailTextLabel!.text = maker.location
            
            return cell
        }
        else {
            let maker = self.projects[indexPath.row]
            cell.textLabel!.text = maker.project_name
            cell.detailTextLabel!.text = maker.location
            
            return cell
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var detailViewController: MakerDetailTableViewController = segue.destinationViewController as! MakerDetailTableViewController
        var makerIndex = makerTableView.indexPathForSelectedRow()!.row
        if (self.resultSearchController.active) {
            var selectedProject = self.searchResults[makerIndex]
            detailViewController.project = selectedProject
        } else {
            var selectedProject = self.projects[makerIndex]
            detailViewController.project = selectedProject
        }
        resultSearchController.active = false
    }
    
    func didReceiveAPIResults(results: NSDictionary) {
        self.refreshControl.endRefreshing()
        indicator.stopAnimating()
        var newProjects: [Project] = []
        
        let allResults: [NSDictionary] = results["accepteds"] as! [NSDictionary]
        
        for result:NSDictionary in allResults {
            var project_name: String? = result["project_name"] as? String
            var project_description: String? = result["description"] as? String
            var web_site: String? = result["web_site"] as? String
            var organization: String? = result["organization"] as? String
            var project_short_summary: String? = result["project_short_summary"] as? String
            
            var location: String? = result["location"] as? String
            //println(location)
            var category: String? = result["category"] as? String
            var photo_link: String? = result["photo_link"] as? String
            
            
            var makerDict: NSDictionary = result["maker"] as! NSDictionary
            var makerName = makerDict["name"] as! String
            var makerDesc = makerDict["description"] as! String
            //var makerPhoto = makerDict["photo_link"] as! String
            
            var maker = Maker(name: makerName, description: makerDesc)
            
            var newProject = Project(project_name: project_name, description: project_description, web_site: web_site, organization: organization, project_short_summary: project_short_summary, photo_link: photo_link, maker: maker, location: location)
            
            newProjects.append(newProject)
        }
        
        self.projects = newProjects
        self.makerTableView.reloadData()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}