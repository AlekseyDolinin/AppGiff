import UIKit
import GoogleMobileAds

class FavoriteViewController: UIViewController, GADBannerViewDelegate, UIGestureRecognizerDelegate {
    
    var favoriteView: FavoriteView! {
        guard isViewLoaded else {return nil}
        return (view as! FavoriteView)
    }
    
    var bannerView: GADBannerView!
    var typeContent = String()
    var arrayLinks = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoriteView.collection.delegate = self
        favoriteView.collection.dataSource = self
        
        favoriteView.configure(typeContent)
        setGadBanner()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTrandingCollection), name: NSNotification.Name(rawValue: "reloadTrandingCollection"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getTrending(typeContent: typeContent)
        print(arrayLinks)
    }
    
    @objc func reloadTrandingCollection() {
        favoriteView.collection.reloadData()
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
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTrandingCollection"), object: nil)
    }
    
    func getTrending(typeContent: String) {
//        print(typeContent)
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
            arrayLinks = StartViewController.arrayFavoritesURL
            reloadCollection()
        }
    }
    
    func reloadCollection() {
        favoriteView.collection.reloadData()
        favoriteView.showCollection()
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
