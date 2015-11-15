//
//  ImageDownloadTask.swift
//  Maker Faire Orlando
//
//  Created by Conner Brooks on 8/31/15.
//  Copyright (c) 2015 Conner Brooks. All rights reserved.
//

import Foundation
import UIKit

class ImageDownloadManager {
    static let sharedInstance = ImageDownloadManager()
    
    func getDataFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: data)
            }.resume()
    }
    
    func downloadImage(url:NSURL, imageURL:UIImageView){
        println("Started downloading \"\(url.lastPathComponent!.stringByDeletingPathExtension)\".")
        getDataFromUrl(url) { data in
            dispatch_async(dispatch_get_main_queue()) {
                println("Finished downloading \"\(url.lastPathComponent!.stringByDeletingPathExtension)\".")
                imageURL.image = UIImage(data: data!)
            }
        }
    }
}