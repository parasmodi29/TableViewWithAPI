

import Foundation
import UIKit


class Helper {
  
  // MARK: - Show Alert
  static func showAlert(_ viewController: UIViewController) {
    
    let alertController = UIAlertController(title: "No Internet", message: "You are not connected to the Internet", preferredStyle: UIAlertController.Style.alert)
    
    let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel) { (action) in
    }
    
    alertController.addAction(okAction)
    
    viewController.present(alertController, animated: true, completion: nil)
  }
  
  // MARK: - Draw Image From PDF URL
  static func drawPDFfromURL(url: URL) -> UIImage? {
    
    guard let document = CGPDFDocument(url as CFURL) else { return nil }
    guard let page = document.page(at: 1) else { return nil }
    
    let pageRect = page.getBoxRect(.mediaBox)
    let renderer = UIGraphicsImageRenderer(size: pageRect.size)
    let img = renderer.image { ctx in
      UIColor.white.set()
      ctx.fill(pageRect)
      
      ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
      ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
      
      ctx.cgContext.drawPDFPage(page)
    }
    
    return img
  }
}


