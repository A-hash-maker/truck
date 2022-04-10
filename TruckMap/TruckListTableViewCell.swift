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
    @IBOutlet weak var truckBatteryImg: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    var item: Truck! {
        didSet {
            truckNumberLbl.text = item.truckNumber
            
            let value = item.lastWaypoint?.createTime ?? 0
            let date1 = Date(milliseconds: Int64(value))
            let date2 = Date()
            
            let dateComponents = daysBetween(start: date2, end: date1)
            var changeText = ""
            if(dateComponents.0 != 0) {
                lastUpdatedLbl.text = "\(dateComponents.0) days ago"
                changeText = "\(dateComponents.0)"
            }else if(dateComponents.1 != 0) {
                changeText = "\(dateComponents.1)"
                lastUpdatedLbl.text = "\(dateComponents.1) hours ago"
            }else if(dateComponents.2 != 0) {
                changeText = "\(dateComponents.2)"
                lastUpdatedLbl.text = "\(dateComponents.2) minutes ago"
            }else if(dateComponents.3 != 0) {
                changeText = "\(dateComponents.3)"
                lastUpdatedLbl.text = "\(dateComponents.3) seconds ago"
            }
            
            lastUpdatedLbl.halfTextColorChange(fullText: lastUpdatedLbl.text!, changeText: changeText, changeColor: AppColor.REDCOLOR)
            
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
            
            let speed = item.lastWaypoint!.speed ?? 0
            if speed != 0 {
                speedRunningLbl.text = "\(speed)" + " Km/hr"
                speedRunningLbl.halfTextColorChange(fullText: speedRunningLbl.text!, changeText: "\(speed)", changeColor: AppColor.REDCOLOR)
            }else {
                speedRunningLbl.text = ""
            }
            
            let batteryPower = item.lastWaypoint.batteryPower ?? false
            
            if batteryPower == true {
                truckBatteryImg.image = UIImage(named: "battery")
            }else {
                truckBatteryImg.image = UIImage(named: "truck")!.withRenderingMode(.automatic)
            }
            
        }
    }
    
    
    
    func daysBetween(start: Date, end: Date) -> (Int, Int, Int, Int) {
        
        let dateComponents = Calendar.current.dateComponents([Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second], from: end, to: start)
        
        return (dateComponents.day!, dateComponents.hour!, dateComponents.minute!, dateComponents.second!)
    }
    
    
}
