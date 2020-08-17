import UIKit
import GoogleMobileAds

class DetailViewController: UIViewController, GADBannerViewDelegate, GADInterstitialDelegate, UIGestureRecognizerDelegate {
    
    var detailView: DetailView! {
        guard isViewLoaded else {return nil}
        return (view as! DetailView)
    }
    
    var linkCurrentImage = String()
    var arrayLinks = [String]()
    var interstitial: GADInterstitial!
    var bannerView: GADBannerView!
    var countShowFullViewAds = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailView.configure()
        
        configure()
        setGadBanner()
        setGadFullView()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func configure() {
        detailView.detailCollectionView.delegate = self
        detailView.detailCollectionView.dataSource = self
    }
    
    @objc func sendGifAction() {
        if interstitial.isReady == true && countShowFullViewAds % 2 == 0 {
            print("ролик готов")
            interstitial.present(fromRootViewController: self)
        } else {
            showControllerShare()
        }
    }
    
    func showControllerShare() {
        let dataGifForSend = Storage.storage[linkCurrentImage]
        let shareController = UIActivityViewController(activityItems: [dataGifForSend!], applicationActivities: nil)
        shareController.completionWithItemsHandler = {_, bool, _, _ in
            if bool {
                print("it is done!")
            } else {
                print("error send")
            }
        }
        countShowFullViewAds = countShowFullViewAds + 1
        present(shareController, animated: true, completion: nil)
    }
    
    @IBAction func searchAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "searchVC") as! SearchViewController
        vc.dataTransition = ["typeSearch": TypeSearch.searchGifs]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
