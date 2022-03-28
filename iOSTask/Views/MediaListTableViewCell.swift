
import UIKit

class MediaListTableViewCell: UITableViewCell {
  
  @IBOutlet weak var lblMediaDate: UILabel!
  @IBOutlet weak var lblMediaID: UILabel!
  @IBOutlet weak var lblMediaTitle: UILabel!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  // MARK: - Configure Cell
  func configureCell(_ media: MediaDetails) {
    
    if let mediaDate = media.mediaDate {
      
      if let dateString = mediaDate.dateString {
        
        let strDate = Date.convertDateUTCToLocal(strDate: dateString, oldFormate: "E, d MMM yyyy HH:mm:ss Z", newFormate: "MM/dd/yyyy")
        self.lblMediaDate.text = strDate
        
      }
      
    }
    
    self.lblMediaID.text = "ID: \(media.mediaId ?? 0)"
    
    self.lblMediaTitle.text = media.mediaTitleCustom ?? ""
    
  }
}
