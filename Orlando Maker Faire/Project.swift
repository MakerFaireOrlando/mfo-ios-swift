//
//  Maker.swift
//  Maker Faire Orlando
//
//  Created by Conner Brooks on 6/10/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

import Foundation

class Project : NSObject {
    
    var category:String?
    var project_name:String?
    var project_description:String?
    var web_site:String?
    var project_short_summary:String?
    var location:String?
    var organization:String?
    var photo_link:String?
    var maker:Maker?
    
    
    init(project_name:String!, description:String!, web_site:String!, organization:String!, project_short_summary:String!, photo_link:String!, maker:Maker!, location:String!) {
        self.project_name = project_name
        self.project_description = description
        self.web_site = web_site
        self.organization = organization
        self.project_short_summary = project_short_summary
        self.location = location
        self.photo_link = photo_link
        self.maker = maker
    }
}