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
            
            let date = Date() // current date
            let unixtime = date.timeIntervalSince1970
            var epocTime = TimeInterval(value)

            let myDate = Date(timeIntervalSince1970: epocTime)
//            println("Converted Time \(myDate)")
//            myDate.
            
            let days = daysBetween(start: myDate, end: Date())
            
            lastUpdatedLbl.text = "Last Updated on \(days) before"
            
            if let status = item.lastRunningState?.truckRunningState {
                if status == 0 {
                    runningStateLbl.text = "Stop"
                }else {
                    runningStateLbl.text = "Running"
                }
            }
            
            speedRunningLbl.text = "\(item.lastWaypoint?.speed ?? 0)" + " Km/hr"
        }
    }
    
    
    
    func daysBetween(start: Date, end: Date) -> Int {
            return Calendar.current.dateComponents([.day], from: start, to: end).day!
        }

    
    
}
