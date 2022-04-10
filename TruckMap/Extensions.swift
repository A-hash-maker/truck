//
//  Extensions.swift
//  TruckMap
//
//  Created by Mac on 07/04/22.
//

import Foundation
import MapKit

// Date extension
extension Date {
    
    static func getStringFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    
}

extension Int {
    
    static func getDateFromString() -> Date? {
        let formatter = ISO8601DateFormatter()
        let dateString = "\(self)"
        formatter.formatOptions = [.withInternetDateTime,
                                   .withDashSeparatorInDate,
                                   .withFullDate,
                                   .withFractionalSeconds,
                                   .withColonSeparatorInTimeZone]
        guard let date = formatter.date(from: dateString) else {
            return nil
        }
        return date
    }
}


extension Date {
    var millisecondsSince1970: Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

extension UIImage {

    func colorized(color : UIColor) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        context!.setBlendMode(.multiply)
//        CGContext.draw
//        CGContextDrawImage(context, rect, self.cgImage)
        context!.clip(to: rect, mask: self.cgImage!)
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let colorizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return colorizedImage!
    }
}

extension UILabel {
    func halfTextColorChange(fullText : String , changeText : String, changeColor: UIColor) {
        let strNumber: NSString = fullText as NSString
        let range = (strNumber).range(of: changeText)
        let attribute = NSMutableAttributedString.init(string: fullText)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: changeColor, range: range)
        self.attributedText = attribute
    }
}
