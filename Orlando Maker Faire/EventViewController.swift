//
//  SecondViewController.swift
//  Orlando Maker Faire
//
//  Created by Conner Brooks on 6/8/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

import UIKit

class EventViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, EventAPIProtocol {
    
    @IBOutlet weak var daySegmentedControl: UISegmentedControl!

    let kCellIdentifier: String = "EventCell"
    var refreshControl:UIRefreshControl!
    
    var api: EventAPI?
    
    @IBOutlet var eventTableView : UITableView!
    
    
    var events: [[Event]] = [[]]
    

    let indicator:UIActivityIndicatorView = UIActivityIndicatorView  (activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.api = EventAPI(delegate: self)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.api?.getEvents()
        self.daySegmentedControl.addTarget(self, action: Selector("handleSegment:"), forControlEvents: UIControlEvents.ValueChanged)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.tintColor = UIColor.redColor()
        //self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.eventTableView.addSubview(refreshControl)
        
        
        
        indicator.color = UIColor.redColor()
        indicator.frame = CGRectMake(0.0, 0.0, 36.0, 36.0)
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        indicator.bringSubviewToFront(self.view)
        indicator.startAnimating()
        
    }
    
    func refresh(sender:AnyObject)
    {
        self.api?.getEvents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events[daySegmentedControl.selectedSegmentIndex].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as! UITableViewCell
        
        
        let event = self.events[daySegmentedControl.selectedSegmentIndex][indexPath.row]
        cell.textLabel!.text = event.name
        if event.end_time != "" {
            cell.detailTextLabel!.text = (event.start_time ?? "") + " - " + (event.end_time ?? "")
        } else {
            cell.detailTextLabel!.text = event.start_time
        }
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var detailViewController: EventDetailTableViewController = segue.destinationViewController as! EventDetailTableViewController
        var eventIndex = eventTableView.indexPathForSelectedRow()!.row
        var selectedEvent = self.events[daySegmentedControl.selectedSegmentIndex][eventIndex]
        detailViewController.event = selectedEvent
        
    }
    
    func didReceiveAPIResults(results: NSDictionary) {
        self.refreshControl.endRefreshing()
        indicator.stopAnimating()
        
        let days: NSArray = results["days"] as! NSArray
        
        var newEvents: [[Event]] = [[]]
        
        newEvents.append([Event]())
        let count = days.count - 1
        for dayCounter in 0...count {
            let day: NSDictionary = days[dayCounter] as! NSDictionary
            let date_title = day["date_title"] as! NSString
            // daySegmentedControl.setTitle(day["date_title"] as! String!, forSegmentAtIndex: 0)
            println("date_title = \(date_title)")
            let ev: [NSDictionary] = day["events"] as! [NSDictionary]
            for e in ev {
                //let name = e["name"] as! NSString
                //println("name = \(name)")
                
                var name: String? = e["name"] as? String
                var image_large: String? = e["image_large"] as? String
                var image_medium: String? = e["image_medium"] as? String
                var description: String? = e["description"] as? String
                var date: String? = e["date"] as? String
                var start_time: String? = e["start_time"] as? String
                var end_time: String? = e["end_time"] as? String
                var duration: String? = e["duration"] as? String
                var cost: String? = e["cost"] as? String
                var additional_info: String? = e["additional_info"] as? String
                var location: String? = e["location"] as? String
                /*
                var link: String? = e["promo_url"] as? String
                
                var startString : String = "1/1/90" // startDict["dateTime"] as! String
                var endString : String = "1/2/91" // endDict["dateTime"] as! String
                
                var formatter: NSDateFormatter = NSDateFormatter()
                formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'-'HH':'mm'"
                
                var start: NSDate = NSDate.new()
                var end: NSDate = NSDate.new()
*/
                
                //var newEvent = Event(summary: summary, event_description: event_description, location: location, link: link, start: start, end: end)
                var newEvent = Event(name: name, image_large: image_large, image_medium: image_medium, description: description, date: date, start_time: start_time, end_time: end_time, duration: duration, cost: cost, additional_info: additional_info, location: location)
                
                newEvents[dayCounter].append(newEvent)
            }
        }
        
        self.events = newEvents
        self.eventTableView.reloadData()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }

    func handleSegment(daySegment: UISegmentedControl) {
        println("sel = \(daySegment.selectedSegmentIndex)")
        self.eventTableView.reloadData()
    }
}
