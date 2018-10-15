//
//  Airport.swift
//  Voos
//
//  Created by Carlos Alexandre Moscoso on 07/10/18.
//  Copyright © 2018 Carlos Moscoso. All rights reserved.
//

import Foundation

//let lat = (d["latitude"] as! NSNumber).doubleValue
//let lon = (d["longitude"] as! NSNumber).doubleValue
//let coordinate = CLLocationCoordinate2DMake(lat, lon)
struct Airport: Codable {
    let code: String
    let name: String
    let displayName: String
}
