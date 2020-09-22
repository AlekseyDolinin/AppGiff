import UIKit
import GoogleMobileAds

class DetailViewController: UIViewController, GADBannerViewDelegate, GADInterstitialDelegate, UIGestureRecognizerDelegate {
    
    var detailView: DetailView! {
        guard isViewLoaded else {return nil}
        return (view as! DetailView)
    }
    
    static var linkCurrentImage = String()
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDetailCollection), name: NSNotification.Name(rawValue: "reloadDetailCollection"), object: nil)
    }
    
    @objc func reloadDetailCollection() {
        detailView.detailCollectionView.reloadData()
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
    
    @objc func favoriteAction(sender: UIButton) {
        // если gif уже в избранном
        if let indexGIF = StartViewController.arrayFavoritesURL.firstIndex(of: arrayLinks[sender.tag]) {
            StartViewController.removeFromFavorite(index: indexGIF)
        } else {
            // если gif нет в избранном
            StartViewController.addNewFavorite(link: arrayLinks[sender.tag])
        }
        // reload collection
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadDetailCollection"), object: nil)
    }
    
    func showControllerShare() {
        let dataGifForSend = Storage.storage[DetailViewController.linkCurrentImage]
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
        vc.tag = nil
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
