import UIKit
import GoogleMobileAds

class CollectionViewController: UIViewController, GADBannerViewDelegate, UIGestureRecognizerDelegate {
    
    var collectionView: CollectionView! {
        guard isViewLoaded else {return nil}
        return (view as! CollectionView)
    }
    
    var bannerView: GADBannerView!
    var typeContent = String()
    var arrayLinks = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collection.delegate = self
        collectionView.collection.dataSource = self
        
        collectionView.configure(typeContent)
        setGadBanner()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getTrending(typeContent: typeContent)
    }
    
    func getTrending(typeContent: String) {
        print(typeContent)
        if typeContent == "gifs" {
            Api.shared.loadTrendingGifs {[weak self] (arrayUrlGifs) in
                self?.arrayLinks = arrayUrlGifs
                self?.reloadCollection()
            }
        } else if typeContent == "stickers" {
            Api.shared.loadTrendingStickers {[weak self] (arrayUrlStickers) in
                self?.arrayLinks = arrayUrlStickers
                self?.reloadCollection()
            }
        } else if typeContent == "Favorite" {
            arrayLinks = arrayFavoritesURL
            reloadCollection()
        }
    }
    
    func reloadCollection() {
        collectionView.collection.reloadData()
        collectionView.showCollection()
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
