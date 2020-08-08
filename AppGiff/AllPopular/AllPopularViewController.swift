import UIKit
import SwiftyJSON
import GoogleMobileAds
import Alamofire

class AllPopularViewController: UIViewController, UIScrollViewDelegate, GADBannerViewDelegate {
    
    static let shared = AllPopularViewController()
    
    private var allPopularView: AllPopularView! {
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
        setGestureBack()
        getPopular(typeContent: typeContent)
    }
    
    func setGestureBack() {
        var swipeRight = UISwipeGestureRecognizer()
        swipeRight.direction = .right
        swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(backAction))
        self.view.addGestureRecognizer(swipeRight)
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
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: true, completion: nil)
    }
}

extension AllPopularViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayPopularLinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let allCell = collectionView.dequeueReusableCell(withReuseIdentifier: "allCell", for: indexPath) as! AllPopularCollectionViewCell
        //если нашлась data в кэше
        if let dataImage = CachData.shared.imageCachData.object(forKey: arrayPopularLinks[indexPath.row] as NSString) {
            allCell.imageGif.image = UIImage.gifImageWithData(dataImage as Data)
        } else {
            //если не нашлась data в кэше - скачиваем по ссылке
            Api.shared.loadData(urlString: arrayPopularLinks[indexPath.row]) { [weak self] (dataImage) in
                // кэширование data
                CachData.shared.imageCachData.setObject(dataImage as NSData, forKey: (self?.arrayPopularLinks[indexPath.row])! as NSString)
                allCell.imageGif.image = UIImage.gifImageWithData(dataImage)
                self?.allPopularView.allPopularCollectionView.reloadData()
            }
        }
        return allCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthCell = allPopularView.allPopularCollectionView.frame.size.width / 2
        
        return CGSize(width: widthCell, height: widthCell * 2 / 3)
    }

//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let transition = CATransition()
//        transition.duration = 0.3
//        transition.type = CATransitionType.push
//        transition.subtype = CATransitionSubtype.fromRight
//        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
//        let vc = storyboard?.instantiateViewController(withIdentifier: "detailVC") as! DetailViewController
//        vc.currentIndex = indexPath.row
//        vc.nameCurrentCollection = "popular"
//        vc.currentData = currentCollection
//        view.window!.layer.add(transition, forKey: kCATransition)
//        vc.modalPresentationStyle = .fullScreen
//        present(vc, animated: false, completion: nil)
//    }
}
