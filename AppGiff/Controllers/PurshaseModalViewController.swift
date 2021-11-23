import UIKit

let appGiffRemoveADSID = "appGiffRemoveADSID"

class PurshaseModalViewController: UIViewController {
    
    let priceManager = PriceManager()
    var storeManager = StoreManager()
    var priceRemoveADS = UserDefaults.standard.object(forKey: appGiffRemoveADSID)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///
        NotificationCenter.default.addObserver(forName: nPricesUpdated, object: nil, queue: nil) { notification in
            print("Обновление цен: \(self.priceRemoveADS)")
        }
        
        /// получение цен покупок
        priceManager.getPricesForInApps(inAppsIDs: [appGiffRemoveADSID])
    }

    
    ///
    @IBAction func getFullVersion() {
        print("getFullVersion")
        storeManager.buyInApp(inAppID: appGiffRemoveADSID)
    }
    
    ///
    @IBAction func close() {
        dismiss(animated: true)
    }
}
