//
//  EventDetailTableViewController.swift
//  Maker Faire Orlando
//
//  Created by Conner Brooks on 8/30/15.
//  Copyright (c) 2015 Conner Brooks. All rights reserved.
//

import UIKit


class EventDetailTableViewController : UITableViewController {
 
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventCost: UILabel!
    @IBOutlet weak var eventDuration: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var eventAdditionalInfo: UITextView!
    
    
    var event:Event?
    
    /*
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
    }*/
    
    override func viewDidAppear(animated: Bool) {
        
        tableView.reloadData()
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //load image
        if event?.image_medium != nil {
        let checkedUrl = NSURL(string: (event?.image_medium ?? ""))
            ImageDownloadManager.sharedInstance.downloadImage(checkedUrl!, imageURL: eventImage)
        }
        
        self.title = event?.name
        
        eventTitle.text = event?.name
        eventLocation.text = event?.location
        if event?.end_time != "" {
            var timeText = (event?.start_time ?? "") + " - " + (event?.end_time ?? "")
            eventTime.text = timeText
        } else {
            eventTime.text = event?.start_time
        }
        
        eventCost.text = event?.cost
        eventDuration.text = event?.duration
        eventDescription.text = event?.event_description
        //eventAdditionalInfo.text = event?.additional_info
        
        var modifiedFont = NSString(format:"<span style=\"font-family: HelveticaNeue-Light; font-size: 17\">%@</span>", (event?.additional_info ?? "")) as String
        
        var attrStr = NSAttributedString(
            data: modifiedFont.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
            options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding],
            documentAttributes: nil,
            error: nil)

        eventAdditionalInfo.attributedText = attrStr
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}