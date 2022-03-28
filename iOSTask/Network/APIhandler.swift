
import UIKit
import Alamofire

class APIhandler: NSObject {

  // MARK: - Static
  static let shared: APIhandler = {
    let instance = APIhandler()
    return instance
  }()
  
  // MARK: - Get Base URL
  fileprivate func getBaseURL() -> String {
    return Constants.kBaseURL
  }
  
  // MARK: - Get URL Of Data Request
  internal func getURL(path: String,pathVariables: [String:Any]?, queryParams: [String:Any]?) -> URL {
    
    var resultingPath = self.getBaseURL() + path
    
    if let pathVariables = pathVariables {
      for (key, value) in pathVariables {
        resultingPath = resultingPath.replacingOccurrences(of: key, with: "\(value)")
      }
    }
    
    let encodedString = resultingPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)
    
    var urlComponents = URLComponents(string: encodedString!)
    
    if let queryParams = queryParams {
      urlComponents?.queryItems = []
      for (key, value) in queryParams {
        urlComponents?.queryItems?.append(URLQueryItem(name: key, value: "\(value)"))
      }
    }
    
    return urlComponents!.url!
  }
  
  // MARK: - Data Request
  internal func getDataRequest(url: URL, method: HTTPMethod, bodyData: [String:Any]?, completion: @escaping(DataRequest?, Error?) -> Void) {
    
    let dataRequest = AF.request(url, method: method, parameters: bodyData, encoding: JSONEncoding.default, headers: nil)
    
    dataRequest.response() { response in
      
      if let httpURLResponse = response.response {
        
        if httpURLResponse.statusCode == 200 {
          completion(dataRequest,nil)
        }else {
          completion(dataRequest,response.error)
        }
        
      }else {
        completion(dataRequest,response.error)
      }
      
    }
  }
  
  // MARK: - Get Response of Any Data Request
  internal func getResponse <T: Codable> (method: HTTPMethod, url: URL, bodyData: [String:Any]?, completion: @escaping (T?, String?) -> Void) {
    
    getDataRequest(url: url, method: method, bodyData: bodyData) { dataRequest, error in
      guard let dataRequest = dataRequest, error == nil else {
        completion(nil, error?.localizedDescription)
        return
      }
      
      dataRequest
        .response() { response in
          guard let data = response.data, response.error == nil else {
            completion(nil, response.error?.localizedDescription)
            return
          }
          do {
            
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            completion(decodedData, nil)
            
          } catch {
            
              completion(nil,nil)
          }
         
      }
    }
  }
  
  // MARK: - Get Response For Request
  func getReponseForRequest(requestURL:URL, bodyPerameter: [String:Any]?,methodName:HTTPMethod,completion: @escaping(DataResponse?, String?) -> Void) {
      
      getResponse(method:methodName, url:requestURL, bodyData:bodyPerameter) { (apiResponse,Error) in
          
          completion(apiResponse,Error)
      }
      
  }
  
}
