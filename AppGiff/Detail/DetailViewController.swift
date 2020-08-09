import UIKit
import GoogleMobileAds

class DetailViewController: UIViewController, GADBannerViewDelegate, GADInterstitialDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var detailCollectionView: UICollectionView!
    @IBOutlet weak var backImage: UIImageView!
    
    var linkCurrentImage = String()
    var arrayLinks = [String]()
    var dataGifForSend = Data()
    var interstitial: GADInterstitial!
    var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        detailCollectionView.delegate = self
        detailCollectionView.dataSource = self
        
        setGadBanner()
        setGadFullView()
        
        backImage.image = UIImage.gifImageWithName("back")
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    @objc func sendGifAction() {
        if interstitial.isReady == true {
            print("ролик готов")
            interstitial.present(fromRootViewController: self)
        } else {
            showControllerShare()
        }
    }
    
    func showControllerShare() {
        let shareController = UIActivityViewController(activityItems: [dataGifForSend], applicationActivities: nil)
        shareController.completionWithItemsHandler = {_, bool, _, _ in
            if bool {
                print("it is done!")
            } else {
                print("error send")
            }
        }
        present(shareController, animated: true, completion: nil)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
