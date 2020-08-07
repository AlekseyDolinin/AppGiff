import UIKit
import GoogleMobileAds

class MainViewController: UIViewController, GADBannerViewDelegate {
    
    var mainView: MainView! {
        guard isViewLoaded else {return nil}
        return (view as! MainView)
    }
    
    var bannerView: GADBannerView!
    var titles = ["#thumbs up", "#shrug", "#yes", "#no", "#wow", "#mad", "#excited", "#bye", "#happy", "#hello", "#love"]
    
    var arrayPopularGifsLinks = [String]()
    var arrayPopularStickersLinks = [String]()
    
    var imageCachData = NSCache<NSString, NSData>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGadBanner()
        mainView.configure()
        getRndGif()
        getPopular()
        configureCollection()
    }
    
    func getRndGif() {
        let randomTitle = titles.randomElement()!
        ApiRandom.shared.getDataRndGif(randomTitle: randomTitle) {(data) in
            self.mainView.setTitle(title: randomTitle, randomDataGif: data)
            self.mainView.showLabel()
        }
    }
    
    func getPopular() {
        ApiRandom.shared.loadPopularGifs {(arrayUrlGifs) in
            self.arrayPopularGifsLinks = arrayUrlGifs
            self.mainView.popularGifCollection.reloadData()
        }
        ApiRandom.shared.loadPopularStickers {(arrayUrlStickers) in
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
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        let vc = storyboard?.instantiateViewController(withIdentifier: "searchVC") as! SearchViewController
        vc.typeSearch = TypeSearch.searchGifs
        view.window!.layer.add(transition, forKey: kCATransition)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
    
    @IBAction func seeAll(_ sender: UIButton) {
//        let transition = CATransition()
//        transition.duration = 0.3
//        transition.type = CATransitionType.push
//        transition.subtype = CATransitionSubtype.fromRight
//        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
//        let vc = storyboard?.instantiateViewController(withIdentifier: "allPopularVC") as! AllPopularViewController
//
//        if sender.restorationIdentifier == "gifs" {
//            vc.typeContent = "gifs"
//        } else if sender.restorationIdentifier == "stickers" {
//            vc.typeContent = "stickers"
//        }
//
//        view.window!.layer.add(transition, forKey: kCATransition)
//        vc.modalPresentationStyle = .fullScreen
//        present(vc, animated: false, completion: nil)
    }
    
    @IBAction func selectTag(_ sender: UIButton) {
        var tag = sender.titleLabel!.text!
        tag.removeFirst()
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        let vc = storyboard?.instantiateViewController(withIdentifier: "searchVC") as! SearchViewController
        vc.typeSearch = "tag"
        vc.searchText = tag
        view.window!.layer.add(transition, forKey: kCATransition)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
}
