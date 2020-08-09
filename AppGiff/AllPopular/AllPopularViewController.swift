import UIKit
import GoogleMobileAds

class AllPopularViewController: UIViewController, GADBannerViewDelegate, UIGestureRecognizerDelegate {
    
    var allPopularView: AllPopularView! {
        guard isViewLoaded else {return nil}
        return (view as! AllPopularView)
    }
    
    var dataTransition = [String: Any]()
    var bannerView: GADBannerView!
    var typeContent = String()
    var arrayPopularLinks = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let typeContent: String = dataTransition["typeContent"] as! String
        
        allPopularView.allPopularCollectionView.delegate = self
        allPopularView.allPopularCollectionView.dataSource = self
        
        allPopularView.configure(typeContent)
        getPopular(typeContent: typeContent)
        setGadBanner()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func getPopular(typeContent: String) {
        if typeContent == "gifs" {
            Api.shared.loadPopularGifs {[weak self] (arrayUrlGifs) in
                self?.arrayPopularLinks = arrayUrlGifs
                self?.allPopularView.allPopularCollectionView.reloadData()
                self?.allPopularView.showCollection()
            }
        } else if typeContent == "stickers" {
            Api.shared.loadPopularStickers {[weak self] (arrayUrlStickers) in
                self?.arrayPopularLinks = arrayUrlStickers
                self?.allPopularView.allPopularCollectionView.reloadData()
                self?.allPopularView.showCollection()
            }
        }
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
