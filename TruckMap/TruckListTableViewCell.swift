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
            
            let value = item.lastWaypoint?.createTime ?? 0
            
            var date = Int(NSDate().timeIntervalSince1970)
            
            print("Currenr miliSeconsd is \(date)")
            
            var date1 = Date(milliseconds: Int64(value))
            var date2 = Date()
            
            let dateComponents = daysBetween(start: date2, end: date1)
            
            print("Days -> \(dateComponents.0)")
            print("Hour -> \(dateComponents.1)")
            print("Minutes -> \(dateComponents.2)")
            print("Seconds -> \(dateComponents.3)")
            
            
            var epocTime = TimeInterval(value)
            
            print("Current miliseconds is -> \(date)")
            print("")
            

            let finalMiliSeconds = date - value
            print("Mili Seconds ->\(finalMiliSeconds)")
            
            let finalTimevalue = secondsToHoursMinutesSeconds(value)
            
//            let date = Date() // current date
//            let unixtime = date.timeIntervalSince1970
//            var epocTime = TimeInterval(value)
            
            let finalTime = secondsToHoursMinutesSeconds(finalMiliSeconds)
            
            let days = finalTime.0
            let hour = finalTime.1
            let minutes = finalTime.2
            let seconds = finalTime.3
            

//            let myDate = Date(timeIntervalSince1970: epocTime)
//            let days = daysBetween(start: myDate, end: Date())
            if(dateComponents.0 != 0) {
                lastUpdatedLbl.text = "\(dateComponents.0) days ago"
            }else if(dateComponents.1 != 0) {
                lastUpdatedLbl.text = "\(dateComponents.1) hours ago"
            }else if(dateComponents.2 != 0) {
                lastUpdatedLbl.text = "\(dateComponents.2) minutes ago"
            }else if(dateComponents.3 != 0) {
                lastUpdatedLbl.text = "\(dateComponents.3) seconds ago"
            }
            
//            lastUpdatedLbl.text = "\(days) days ago"
            
            if let status = item.lastRunningState?.truckRunningState {
                if status == 0 {
                    if(dateComponents.0 != 0) {
                        runningStateLbl.text = "Stopped since last \(dateComponents.0) days"
                    }else if(dateComponents.1 != 0) {
                        runningStateLbl.text = "Stopped since last \(dateComponents.1) hours"
                    }else if(dateComponents.2 != 0) {
                        runningStateLbl.text = "Stopped since last \(dateComponents.2) minutes"
                    }else if(dateComponents.3 != 0) {
                        runningStateLbl.text = "Stopped since last \(dateComponents.3) seconds"
                    }
                }else {
                    if(dateComponents.0 != 0) {
                        runningStateLbl.text = "Running since last \(dateComponents.0) days"
                    }else if(dateComponents.1 != 0) {
                        runningStateLbl.text = "Running since last \(dateComponents.1) hours"
                    }else if(dateComponents.2 != 0) {
                        runningStateLbl.text = "Running since last \(dateComponents.2) minutes"
                    }else if(dateComponents.3 != 0) {
                        runningStateLbl.text = "Running since last \(dateComponents.3) seconds"
                    }
                }
            }
            
            speedRunningLbl.text = "\(item.lastWaypoint?.speed ?? 0)" + " Km/hr"
        }
    }
    
    
    
    func daysBetween(start: Date, end: Date) -> (Int, Int, Int, Int) {
        
        let dateComponents = Calendar.current.dateComponents([Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second], from: end, to: start)
        
        return (dateComponents.day!, dateComponents.hour!, dateComponents.minute!, dateComponents.second!)
    }
    
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int, Int) {
        return ((seconds / 86400), seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }

    
    
}
