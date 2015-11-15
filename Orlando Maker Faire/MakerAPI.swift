//
//  MakerAPI.swift
//  Maker Faire Orlando
//
//  Created by Conner Brooks on 6/12/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

import Foundation

protocol MakerAPIProtocol {
    func didReceiveAPIResults(results: NSDictionary)
}

class MakerAPI {
    
    var delegate: MakerAPIProtocol?
    
    init(delegate: MakerAPIProtocol?) {
        self.delegate = delegate
    }
    
    func getMakers() {
        let urlPath = "http://makerfaireorlando.com/makers-json"
        let url: NSURL = NSURL(string: urlPath)!
        let request: NSURLRequest = NSURLRequest(URL: url)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
            if error != nil {
                println("ERROR: \(error.localizedDescription)")
            }
            else {
                var error: NSError?
                let jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
                // Now send the JSON result to our delegate object
                if (error != nil) {
                    println("HTTP Error: \(error?.localizedDescription)")
                }
                else {
                    println("Results recieved")
                    self.delegate?.didReceiveAPIResults(jsonResult)
                }
            }
        })
    }
}