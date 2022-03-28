
import Foundation
import UIKit

extension DispatchQueue {
  
  // MARK: - Background Thread
  static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
    DispatchQueue.global(qos: .background).async {
      background?()
      if let completion = completion {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
          completion()
        })
      }
    }
  }
}

extension UILabel {
  
  // MARK: - Show Underline
  func underline() {
    guard let text = self.text else { return }
    let attributedString = NSMutableAttributedString(string: text)
    attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: UIColor.link , range: NSRange(location: 0, length: text.count))
    attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.link , range: NSRange(location: 0, length: text.count))
    attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
    self.attributedText = attributedString
  }
  
}

extension Date {
  
  // MARK: - Old Date Format to New and UTC To Local
  static func convertDateUTCToLocal(strDate:String, oldFormate strOldFormate:String, newFormate strNewFormate:String) -> String{
    let dateFormatterUTC:DateFormatter = DateFormatter()
    dateFormatterUTC.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
    dateFormatterUTC.dateFormat = strOldFormate
    if let oldDate:Date = dateFormatterUTC.date(from: strDate)  as Date?
    {
      dateFormatterUTC.timeZone = NSTimeZone.local
      dateFormatterUTC.dateFormat = strNewFormate
      dateFormatterUTC.amSymbol = "am"
      dateFormatterUTC.pmSymbol = "pm"
      if let strNewDate:String = dateFormatterUTC.string(from: oldDate as Date) as String?
      {
        return strNewDate
      }
      return strDate
    }
    return strDate
  }
  
}
