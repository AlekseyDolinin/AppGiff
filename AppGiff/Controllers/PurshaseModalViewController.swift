import UIKit

let appGiffRemoveADSID = "appGiffRemoveADSID"

class PurshaseModalViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var removeADButton: UIButton!
    @IBOutlet weak var restorePurchaseButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var buttonStack: UIStackView!
    
    var storeManager = StoreManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loader.stopAnimating()
        removeADButton.layer.cornerRadius = removeADButton.frame.height / 2
        restorePurchaseButton.layer.cornerRadius = restorePurchaseButton.frame.height / 2
        
        ///
        NotificationCenter.default.addObserver(forName: nTransactionComplate, object: nil, queue: nil) { notification in
            self.dismiss(animated: true)
        }
    }

    ///
    func showLoader() {
        titleLabel.alpha = 0.3
        buttonStack.alpha = 0.3
        cancelButton.alpha = 0.3
        loader.startAnimating()
        view.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.titleLabel.alpha = 1.0
            self.buttonStack.alpha = 1.0
            self.cancelButton.alpha = 1.0
            self.loader.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    ///
    @IBAction func removeAD() {
        print("getFullVersion")
        showLoader()
        storeManager.buyInApp(inAppID: appGiffRemoveADSID)
    }
    
    ///
    @IBAction func restorePurchase() {
        print("restorePurchase")
        showLoader()
        storeManager.restorePurchase()
    }
    
    ///
    @IBAction func close() {
        dismiss(animated: true)
    }
}
