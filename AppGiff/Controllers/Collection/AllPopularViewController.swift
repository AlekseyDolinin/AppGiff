import UIKit
import GoogleMobileAds

class CollectionViewController: UIViewController, GADBannerViewDelegate, UIGestureRecognizerDelegate {
    
    var collectionView: CollectionView! {
        guard isViewLoaded else {return nil}
        return (view as! CollectionView)
    }
    
    var dataTransition = [String: Any]()
    var bannerView: GADBannerView!
    var typeContent = String()
    var arrayTrendingLinks = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let typeContent: String = dataTransition["typeContent"] as! String
        
        collectionView.collection.delegate = self
        collectionView.collection.dataSource = self
        
        collectionView.configure(typeContent)
        getTrending(typeContent: typeContent)
        setGadBanner()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func getTrending(typeContent: String) {
        if typeContent == "gifs" {
            Api.shared.loadTrendingGifs {[weak self] (arrayUrlGifs) in
                self?.arrayTrendingLinks = arrayUrlGifs
                self?.collectionView.collection.reloadData()
                self?.collectionView.showCollection()
            }
        } else if typeContent == "stickers" {
            Api.shared.loadTrendingStickers {[weak self] (arrayUrlStickers) in
                self?.arrayTrendingLinks = arrayUrlStickers
                self?.collectionView.collection.reloadData()
                self?.collectionView.showCollection()
            }
        }
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
