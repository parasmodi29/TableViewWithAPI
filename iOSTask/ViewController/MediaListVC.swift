
import UIKit

class MediaListVC: UIViewController {
  
  // MARK: - @IBOutlet
  @IBOutlet weak var tblView: UITableView!
  @IBOutlet weak var noDataView: UIView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  // MARK: - @var
  var arrMediaList: [MediaDetails] = []
  lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
    return refreshControl
  }()
  
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
    activityIndicator.startAnimating()
    self.tblView.register(UINib(nibName:Constants.TableViewCell.MediaListTableViewCell, bundle:Bundle.main), forCellReuseIdentifier: Constants.TableViewCellID.MediaListCellID)
    self.tblView.estimatedRowHeight = 44.0
    self.tblView.rowHeight = UITableView.automaticDimension
    self.tblView.addSubview(refreshControl)
    self.getMediaList()
  }

  // MARK: - Get URL
  func getUrl() -> URL {
    
    let url =  APIhandler.shared.getURL(path: "test.json", pathVariables:nil, queryParams:nil)
    
    return url
  }
  
  // MARK: - Get Media List
  func getMediaList() {
    
    guard Connectivity.isConnectedToInternet() == true else {
      self.activityIndicator.stopAnimating()
      self.noDataView.isHidden = false
      Helper.showAlert(self)
      return
    }
    
    let url = getUrl()
    
    APIhandler.shared.getReponseForRequest(requestURL: url, bodyPerameter: nil, methodName: .get) { (dataResponse, error) in
      
      self.activityIndicator.stopAnimating()
      
      guard error == nil else {
        self.noDataView.isHidden = false
        return
      }
      
      guard let arrMedia = dataResponse?.content, arrMedia.count != 0 else {
        self.noDataView.isHidden = false
        return
      }
      
      for (_, element) in arrMedia.enumerated() {
        
        self.arrMediaList.append(element)
        
      }
    
      self.tblView.reloadData()
    }
    
  }
  
  
  // MARK: - handle Pull To Refresh Event
  @objc func handleRefresh(_ refreshControl: UIRefreshControl)  {
   
    refreshControl.beginRefreshing()
    
    guard Connectivity.isConnectedToInternet() == true else {
      
      refreshControl.endRefreshing()
      Helper.showAlert(self)
      return
      
    }
    
    let url = getUrl()
    
    APIhandler.shared.getReponseForRequest(requestURL: url, bodyPerameter: nil, methodName: .get) { (dataResponse, error) in
      
      guard error == nil else {
        refreshControl.endRefreshing()
        return
      }
      
      guard let arrMedia = dataResponse?.content, arrMedia.count != 0 else {
        refreshControl.endRefreshing()
        return
      }
      
      if self.arrMediaList.count != arrMedia.count {
        
        self.arrMediaList.removeAll()
        
        for (_, element) in arrMedia.enumerated() {
          
          self.arrMediaList.append(element)
          
        }
      
        self.tblView.reloadData()
      }
     
    }
    
    refreshControl.endRefreshing()
  }
  
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension MediaListVC: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.arrMediaList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let objCell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellID.MediaListCellID, for: indexPath) as? MediaListTableViewCell else {
      return UITableViewCell()
    }
    
    objCell.configureCell(self.arrMediaList[indexPath.row])
    
    return objCell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
    if Connectivity.isConnectedToInternet() == true {
      
      if let objUserDetailVC = Constants.kMainStoryBoard.instantiateViewController(withIdentifier: "MediaDetailVC") as? MediaDetailVC {
        objUserDetailVC.dicMediaDetails = self.arrMediaList[indexPath.row]
        self.navigationController?.pushViewController(objUserDetailVC, animated: true)
      }
      
    }else {
      
      Helper.showAlert(self)
    }
    
    
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
      return true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      
      tableView.beginUpdates()
      self.arrMediaList.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
      tableView.endUpdates()
    }
  }
  
}
