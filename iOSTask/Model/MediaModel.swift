
import Foundation

public struct DataResponse: Codable {
  
  public var status: Bool
  public var lang: String?
  public var content: [MediaDetails]?
  
  public init(status: Bool, lang: String?, content: [MediaDetails]?) {
    self.status = status
    self.lang = lang
    self.content = content
    
  }
  
  public enum CodingKeys: String, CodingKey {
   
    case status
    case lang
    case content
  }
}


public struct MediaDetails: Codable {
  
  public var mediaId: Int?
  public var mediaUrl: String?
  public var mediaUrlBig: String?
  public var mediaType: String?
  public var mediaDate : MediaDate?
  public var mediaTitleCustom: String?

  public init(mediaId: Int?, mediaUrl: String?, mediaUrlBig: String?, mediaType: String?, mediaDate: MediaDate?, mediaTitleCustom: String?) {
    self.mediaId = mediaId
    self.mediaUrl = mediaUrl
    self.mediaUrlBig = mediaUrlBig
    self.mediaType = mediaType
    self.mediaDate = mediaDate
    self.mediaTitleCustom = mediaTitleCustom
  }
  
  public enum CodingKeys: String, CodingKey {
    case mediaId
    case mediaUrl
    case mediaUrlBig
    case mediaType
    case mediaDate
    case mediaTitleCustom
  }
  
}

public struct MediaDate: Codable {
  
  public var dateString: String?
  public var year: String?
  
  public init(dateString: String?, year: String?) {
    self.dateString = dateString
    self.year = year
    
  }
  
  public enum CodingKeys: String, CodingKey {
   
    case dateString
    case year
  }
}
