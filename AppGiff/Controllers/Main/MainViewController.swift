import UIKit
import GoogleMobileAds

//var storage = [String: Data]()

class MainViewController: UIViewController, GADBannerViewDelegate, UIGestureRecognizerDelegate {
    
    var mainView: MainView! {
        guard isViewLoaded else {return nil}
        return (view as! MainView)
    }
    
    var bannerView: GADBannerView!
    var titles = ["#thumbs up", "#shrug", "#yes", "#no", "#wow", "#mad", "#excited", "#bye", "#happy", "#hello", "#love"]
    
    var arrayTrendingGifsLinks = [String]()
    var arrayTrendingStickersLinks = [String]()
    let transition = CATransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTransition()
        setGadBanner()
        mainView.configure()
        getRndGif()
        getTrending()
        configureCollection()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func configureCollection() {
        mainView.trendingGifCollection.delegate = self
        mainView.trendingGifCollection.dataSource = self
        mainView.trendingStickerCollection.delegate = self
        mainView.trendingStickerCollection.dataSource = self
    }
    
    func setTransition() {
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
    }
    
    func getRndGif() {
        let randomTitle = titles.randomElement()!
        Api.shared.getDataRndGif(randomTitle: randomTitle) {(data) in
            self.mainView.setTitleImage(title: randomTitle, randomDataGif: data)
            self.mainView.showLabel()
        }
    }
    
    func getTrending() {
        Api.shared.loadTrendingGifs {(arrayUrlGifs) in
            self.arrayTrendingGifsLinks = arrayUrlGifs
            self.mainView.trendingGifCollection.reloadData()
        }
        Api.shared.loadTrendingStickers {(arrayUrlStickers) in
            self.arrayTrendingStickersLinks = arrayUrlStickers
            self.mainView.trendingStickerCollection.reloadData()
        }
    }
    
    @IBAction func reloadImageTitleAction(_ sender: UIButton) {
        mainView.hideLabel()
        mainView.clearTitleGif()
        getRndGif()
    }
    
    @IBAction func searchAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "searchVC") as! SearchViewController
        vc.tag = nil
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func favoriteAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "collectionVC") as! CollectionViewController
        vc.typeContent = "Favorite"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func seeAll(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "collectionVC") as! CollectionViewController
        vc.typeContent = sender.restorationIdentifier!
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func selectTag(_ sender: UIButton) {
        var tagString = sender.titleLabel!.text!
        tagString.removeFirst()
        let vc = storyboard?.instantiateViewController(withIdentifier: "searchVC") as! SearchViewController
        vc.tag = tagString
        navigationController?.pushViewController(vc, animated: true)
    }
}
