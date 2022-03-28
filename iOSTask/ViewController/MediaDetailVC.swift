
import UIKit

class MediaDetailVC: UIViewController {
  
  // MARK: - @IBOutlet
  @IBOutlet weak var lblDate: UILabel!
  @IBOutlet weak var lblID: UILabel!
  @IBOutlet weak var lblTitle: UILabel!
  @IBOutlet weak var lblLink: UILabel!
  @IBOutlet weak var imgPreview: UIImageView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  // MARK: - @var
  var dicMediaDetails: MediaDetails?
  var pdfPreview: UIImage? = nil
  
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    self.setupView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  // MARK: - setupView
  func setupView() {
    
    self.navigationItem.largeTitleDisplayMode = .never
    self.lblLink.underline()
    
    self.navigationItem.hidesBackButton = false
    
    if let mediaDetails = dicMediaDetails {
      
      if let mediaDate = mediaDetails.mediaDate {
        
        if let dateString = mediaDate.dateString {
          
          let strDate = Date.convertDateUTCToLocal(strDate: dateString, oldFormate: Constants.DateFormats.kOld, newFormate: Constants.DateFormats.kNew)
          self.lblDate.text = strDate
          
        }
        
      }
      
      self.lblID.text = "ID: \(mediaDetails.mediaId ?? 0)"
      
      self.lblTitle.text = mediaDetails.mediaTitleCustom ?? ""
      
      self.lblLink.text = mediaDetails.mediaUrl ?? ""
      
      let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGetsture(_:)))
      self.lblLink.isUserInteractionEnabled = true
      tapGestureRecognizer.numberOfTapsRequired = 1
      self.lblLink.addGestureRecognizer(tapGestureRecognizer)
      
      self.activityIndicator.startAnimating()
      
      DispatchQueue.background(background: {
        // Do something in background
        let mediaUrl = self.getMediaURL()
        guard let url = URL(string: mediaUrl) else { return }
        if let preview = Helper.drawPDFfromURL(url: url) {
          self.pdfPreview = preview
          
        }
      }, completion:{
        // When background job finished, do something in main thread
        self.activityIndicator.stopAnimating()
        self.imgPreview.image = self.pdfPreview
      })
      
    }
  }
  
  // MARK: - Tap Gesture Event
  @objc func tapGetsture(_ getsure: UITapGestureRecognizer) {
    
    let mediaUrl = getMediaURL()
    guard let url = URL(string: mediaUrl) else { return }
    UIApplication.shared.open(url)
    
  }
  
  // MARK: - Get Media URL
  func getMediaURL() -> String {
    
    if let mediaDetails = dicMediaDetails {
      
      if let mediaUrl = mediaDetails.mediaUrl {
        
        return mediaUrl
        
      }else {
        return ""
      }
      
    }else {
      return ""
    }
  }
  
}
