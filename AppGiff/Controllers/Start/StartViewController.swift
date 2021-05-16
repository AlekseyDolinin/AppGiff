import UIKit
//import AdSupport

class StartViewController: UIViewController {
    
    private var startView: StartView! {
        guard isViewLoaded else {return nil}
        return (view as! StartView)
    }
    
    static var arrayFavorites = UserDefaults.standard.array(forKey: "favoriteLinks")
    
    static var arrayFavoritesURL: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getVersionApp()
        
        if let arrayFavoritesURL = StartViewController.arrayFavorites {
//            print("arrayFavoritesURL: \(arrayFavoritesURL)")
            StartViewController.arrayFavoritesURL = arrayFavoritesURL as! [String]
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(requestTrackingAuthorization), name: Notification.Name("requestAppTracking"), object: nil)
        
        if let statusATT =  UserDefaults.standard.string(forKey: "statusATTKey") {
            print("statusATT: \(statusATT)")
            if statusATT == "notDetermined" {
                showModalAppTrackingDescription()
            }
        } else {
            /// если статус нил - запроса не было
            showModalAppTrackingDescription()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MainViewController")
        navigationController?.pushViewController(vc!, animated: true)
    }

    static func addNewFavorite(link: String) {
        StartViewController.arrayFavoritesURL.append(link)
        UserDefaults.standard.set(StartViewController.arrayFavoritesURL, forKey: "favoriteLinks")
        UserDefaults.standard.synchronize()
    }
    
    static func removeFromFavorite(index: Int) {
        StartViewController.arrayFavoritesURL.remove(at: index)
        UserDefaults.standard.set(StartViewController.arrayFavoritesURL, forKey: "favoriteLinks")
        UserDefaults.standard.synchronize()
    }
    
    
    /// получение номера версии приложения
    func getVersionApp() {
        let nsObject: AnyObject? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject
        let version = nsObject as! String
        startView.setVersionLabel(value: version)
    }
    
    deinit {
        print("deinit StartViewController")
    }
}
