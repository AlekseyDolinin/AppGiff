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
    
    var bannerView: GADBannerView!
    var currentCollection = [Data]()
    var typeContent = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allPopularView.configure()
        setGestureBack()
        
        if typeContent == "gifs" {
            allPopularView.titleLabel.text = "Popular GIF"
        } else if typeContent == "stickers" {
            allPopularView.titleLabel.text = "Popular Stickers"
        }
        getData()
    }
    
    func setGestureBack() {
        var swipeRight = UISwipeGestureRecognizer()
        swipeRight.direction = .right
        swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(back))
        self.view.addGestureRecognizer(swipeRight)
    }
    
    func getData() {
        let stringURL = "https://api.giphy.com/v1/\(typeContent)/trending?api_key=wR3NVODE5rYFwyFQJJH38Vvr8Ts73ufz&limit=300&rating=G"
        request(stringURL).responseData { response in
            if response.error != nil {
                return
            }
            let json = JSON(response.value as Any)
            let arrayUrlPopular = json["data"].arrayValue.map({$0["images"]["fixed_width_downsampled"]["url"].string!})
            self.loadImage(arrayUrl: arrayUrlPopular, completion: { (result) in
                if result == true {
                    self.allPopularView.allPopularCollectionView.reloadData()
                }
            })
        }
    }
    
    func loadImage(arrayUrl: [String], completion: @escaping (Bool) -> ()) {
        for url in arrayUrl {
            request(url).responseData { response in
                if response.error != nil {
                    return
                }
                print(response.data)
                if response.value != nil {
                    self.currentCollection.append(response.value!)
                    completion(true)
                }
            }
        }
    }
    
    @objc func back() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        back()
    }
}

extension AllPopularViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let allCell = collectionView.dequeueReusableCell(withReuseIdentifier: "allCell", for: indexPath) as! AllPopularCollectionViewCell
        allCell.imageGif.image = UIImage.gifImageWithData(currentCollection[indexPath.row])
        return allCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthCell = allPopularView.allPopularCollectionView.frame.size.width / 2
        
        return CGSize(width: widthCell, height: widthCell * 2 / 3)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        let vc = storyboard?.instantiateViewController(withIdentifier: "detailVC") as! DetailViewController
        vc.currentIndex = indexPath.row
        vc.nameCurrentCollection = "popular"
        vc.currentData = currentCollection
        view.window!.layer.add(transition, forKey: kCATransition)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
}
