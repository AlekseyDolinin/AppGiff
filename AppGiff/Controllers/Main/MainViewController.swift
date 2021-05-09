import UIKit
import GoogleMobileAds

class MainViewController: UIViewController, GADBannerViewDelegate, UIGestureRecognizerDelegate {
    
    var mainView: MainView! {
        guard isViewLoaded else {return nil}
        return (view as! MainView)
    }
    
    var bannerView: GADBannerView!
    
    var arrayTags = [String]()
    var arrayTrendingGifsLinks = [String]()
    var arrayTrendingStickersLinks = [String]()
    let transition = CATransition()
    var systemtLanguage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        systemtLanguage = String(Locale.current.languageCode!.prefix(2))
        
        setTransition()
        setGadBanner()
        getTrending()
        getTrendingSearch()
        configureCollection()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        mainView.tagCollection.reloadData()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func configureCollection() {
        mainView.trendingGifCollection.delegate = self
        mainView.trendingGifCollection.dataSource = self
        mainView.trendingStickerCollection.delegate = self
        mainView.trendingStickerCollection.dataSource = self
        mainView.tagCollection.delegate = self
        mainView.tagCollection.dataSource = self
        registerNib()
    }
    
    ///
    func setTransition() {
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
    }
    
    ///
    func registerNib() {
        let nib = UINib(nibName: TagCell.nibName, bundle: nil)
        mainView.tagCollection?.register(nib, forCellWithReuseIdentifier: TagCell.reuseIdentifier)
        if let flowLayout = mainView.tagCollection?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
    }
    
    ///
    func getRndGif() {
        let randomTitle = (arrayTags.randomElement()!)
        mainView.randomTitleLabel.text = "#\(randomTitle)"
        Api.shared.getDataRndGif(randomTitle: randomTitle, language: systemtLanguage) {(data) in
            self.mainView.setTitleImage(randomDataGif: data)
        }
    }
    
    ///
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
    
    ///
    func getTrendingSearch() {
        Api.shared.getTrendingSearch(language: systemtLanguage) { (json) in
            let arrayTrendingSearch = (json["data"].arrayValue).reversed()
            for tag in arrayTrendingSearch {
                let textTag = tag.stringValue
                self.arrayTags.append(textTag)
            }
            if self.arrayTags.count == arrayTrendingSearch.count {
                self.mainView.tagCollection.reloadData()
                self.getRndGif()
            }
        }
    }
    
    ///
    @IBAction func reloadImageTitleAction(_ sender: UIButton) {
        mainView.clearImageGif()
        getRndGif()
    }
    
    @IBAction func favoriteAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "FavoriteVC") as! FavoriteViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func openSearchVC(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true)
    }
}
