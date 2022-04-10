//
//  TruckViewModel.swift
//  TruckMap
//
//  Created by Mac on 07/04/22.
//

import Foundation
import SwiftyJSON

struct TruckViewModel {
    
    var data = [Truck]()
    
    init(json: JSON) {
        if let item = json["data"].array {
            self.data = item.map { Truck(json: $0) }
        }
    }
    
    
}

struct Truck {
    
    var truckNumber: String!
    var lastRunningState: LastRunningState!
    var lastWaypoint: LastWayPoint!
    
    init(json: JSON) {
        truckNumber = json["truckNumber"].stringValue
        lastRunningState = LastRunningState(json: json["lastRunningState"])
        lastWaypoint = LastWayPoint(json: json["lastWaypoint"])
    }
    
}


struct LastRunningState {
    
    var stopStartTime: Int!
    var truckRunningState: Int!
    
    init(json: JSON) {
        stopStartTime = json["stopStartTime"].intValue
        truckRunningState = json["truckRunningState"].intValue
    }
    
    
}


struct LastWayPoint {

    var lng: Double!
    var speed: Double!
    var lat: Double!
    var ignitionOn: Bool!
    var createTime: Int!
    var batteryPower: Bool!
    
    init(json: JSON) {
        lng = json["lng"].doubleValue
        speed = json["speed"].doubleValue
        lat = json["lat"].doubleValue
        ignitionOn = json["ignitionOn"].boolValue
        createTime = json["createTime"].intValue
        batteryPower = json["batteryPower"].boolValue
    }
    
}


