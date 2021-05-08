import UIKit
import GoogleMobileAds

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
        getRndGif()
        getTrending()
        getTrendingSearch()
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
        Api.shared.loadTrending(typeContent: "gifs") {(arrayUrlGifs) in
            self.arrayTrendingGifsLinks = arrayUrlGifs
            self.mainView.trendingGifCollection.reloadData()
        }
        Api.shared.loadTrending(typeContent: "stickers"){(arrayUrlStickers) in
            self.arrayTrendingStickersLinks = arrayUrlStickers
            self.mainView.trendingStickerCollection.reloadData()
        }
    }
    
    func getTrendingSearch() {
        Api.shared.getTrendingSearch { (json) in
            print(json)
        }
        
        
        
    }
    
    @IBAction func reloadImageTitleAction(_ sender: UIButton) {
        mainView.hideLabel()
        mainView.clearTitleGif()
        getRndGif()
    }
    
    @IBAction func favoriteAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "FavoriteVC") as! FavoriteViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func selectTag(_ sender: UIButton) {
        var tagString = sender.titleLabel!.text!
        tagString.removeFirst()
        let vc = storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        vc.searchText = tagString
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true)
    }
    
    @IBAction func openSearchVC(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true)
    }
}
