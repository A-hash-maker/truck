//
//  TruckListTableViewCell.swift
//  TruckMap
//
//  Created by Mac on 07/04/22.
//

import UIKit

class TruckListTableViewCell: UITableViewCell {

    @IBOutlet weak var truckNumberLbl: UILabel!
    @IBOutlet weak var lastUpdatedLbl: UILabel!
    @IBOutlet weak var runningStateLbl: UILabel!
    @IBOutlet weak var speedRunningLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    var item: Truck! {
        didSet {
            truckNumberLbl.text = item.truckNumber
            
//            var value: Int = 0
//
//            value = item.lastRunningState?.stopStartTime ?? 0
            
//            print("Time here is \(value.getDateFromString())")
            
//            if let time: Int = item.lastRunningState?.stopStartTime {
//
//
//                print("date from string is \(Int.getDateFromString())")
//            }
            
            let value = item.lastRunningState?.stopStartTime ?? 0
            
            let date = NSDate() // current date
            let unixtime = date.timeIntervalSince1970
            var epocTime = TimeInterval(value)

            let myDate = NSDate(timeIntervalSince1970: epocTime)
//            println("Converted Time \(myDate)")
//            myDate.
            
            
            lastUpdatedLbl.text = "\(myDate)"
            
            if let status = item.lastRunningState?.truckRunningState {
                if status == 0 {
                    runningStateLbl.text = "Stop"
                }else {
                    runningStateLbl.text = "Running"
                }
            }
            
//            runningStateLbl.text =  "\(item.lastRunningState?.truckRunningState ?? 0)"
            speedRunningLbl.text = "\(item.lastWaypoint?.speed ?? 0)" + " Km/hr"
        }
    }

    
    
}
