
import Foundation
import UIKit

struct Constants {
  
  static let kAppDelegate = UIApplication.shared.delegate as! AppDelegate
  static let kMainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
  static let kBaseURL = "https://apivegans.veganslab.xyz/"
 
  struct DateFormats {
    static let kOld = "E, d MMM yyyy HH:mm:ss Z"
    static let kNew = "MM/dd/yyyy"
  }
  
  struct TableViewCell {
    static let MediaListTableViewCell = "MediaListTableViewCell"
  }
  
  
  struct TableViewCellID {
    static let MediaListCellID = "MediaListCellID"
  }
}
