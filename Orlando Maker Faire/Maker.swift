//
//  Maker.swift
//  Maker Faire Orlando
//
//  Created by Conner Brooks on 8/30/15.
//  Copyright (c) 2015 Conner Brooks. All rights reserved.
//

import Foundation


class Maker {
    
    var name:String?
    var description:String?
    var photo_link:String?
    
    init(name:String!, description:String!, photo_link:String!)
    {
        self.name = name
        self.description = description
        self.photo_link = photo_link
    }
    
    init(name:String!, description:String!)
    {
        self.name = name
        self.description = description
        //self.photo_link = photo_link
    }
    
}