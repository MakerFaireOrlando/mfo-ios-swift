//
//  MakerDetailTableViewController.swift
//  Maker Faire Orlando
//
//  Created by Conner Brooks on 8/30/15.
//  Copyright (c) 2015 Conner Brooks. All rights reserved.
//

import UIKit


class MakerDetailTableViewController : UITableViewController {
    
    @IBOutlet weak var projectImage: UIImageView!
    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var projectLocation: UILabel!
    @IBOutlet weak var projectDescription: UILabel!
    @IBOutlet weak var makerName: UILabel!
    @IBOutlet weak var makerDescription: UILabel!
    
    var project:Project?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.project?.project_name
        
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //load image
        if project?.photo_link != nil {
            let checkedUrl = NSURL(string: (project?.photo_link ?? ""))
            ImageDownloadManager.sharedInstance.downloadImage(checkedUrl!, imageURL: projectImage)
        }
        
        // project
        projectName.text = self.project?.project_name
        projectLocation.text = self.project?.location
        print(self.project?.location)
        projectDescription.text = self.project?.project_description
        
        // maker
        makerName.text = self.project?.maker?.name
        makerDescription.text = self.project?.maker?.maker_description
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}