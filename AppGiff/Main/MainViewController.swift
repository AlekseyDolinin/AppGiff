import UIKit
import GoogleMobileAds

var storage = [String: UIImage?]()

class MainViewController: UIViewController, GADBannerViewDelegate {
    
    var mainView: MainView! {
        guard isViewLoaded else {return nil}
        return (view as! MainView)
    }
    
    var bannerView: GADBannerView!
    var titles = ["#thumbs up", "#shrug", "#yes", "#no", "#wow", "#mad", "#excited", "#bye", "#happy", "#hello", "#love"]
    
    var arrayPopularGifsLinks = [String]()
    var arrayPopularStickersLinks = [String]()
    let transition = CATransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTransition()
        setGadBanner()
        mainView.configure()
        getRndGif()
        getPopular()
        configureCollection()
    }
    
    func configureCollection() {
        mainView.popularGifCollection.delegate = self
        mainView.popularGifCollection.dataSource = self
        mainView.popularStickerCollection.delegate = self
        mainView.popularStickerCollection.dataSource = self
    }
    
    func setTransition() {
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
    }
    
    func getRndGif() {
        let randomTitle = titles.randomElement()!
        Api.shared.getDataRndGif(randomTitle: randomTitle) {(data) in
            self.mainView.setTitle(title: randomTitle, randomDataGif: data)
            self.mainView.showLabel()
        }
    }
    
    func getPopular() {
        Api.shared.loadPopularGifs {(arrayUrlGifs) in
            self.arrayPopularGifsLinks = arrayUrlGifs
            self.mainView.popularGifCollection.reloadData()
        }
        Api.shared.loadPopularStickers {(arrayUrlStickers) in
            self.arrayPopularStickersLinks = arrayUrlStickers
            self.mainView.popularStickerCollection.reloadData()
        }
    }
    
    @IBAction func reloadImageTitleAction(_ sender: UIButton) {
        mainView.hideLabel()
        mainView.clearTitleGif()
        getRndGif()
    }
    
    @IBAction func searchAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "searchVC") as! SearchViewController
        vc.dataTransition = ["typeSearch": TypeSearch.searchGifs]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func seeAll(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "allPopularVC") as! AllPopularViewController
        vc.dataTransition = ["typeContent": sender.restorationIdentifier!]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func selectTag(_ sender: UIButton) {
        var tagString = sender.titleLabel!.text!
        tagString.removeFirst()
        let vc = storyboard?.instantiateViewController(withIdentifier: "searchVC") as! SearchViewController
        vc.dataTransition = ["typeSearch": TypeSearch.searchGifs, "tagString": tagString]
        navigationController?.pushViewController(vc, animated: true)
    }
}
