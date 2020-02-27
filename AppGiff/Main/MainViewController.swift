import UIKit
import GoogleMobileAds



class MainViewController: UIViewController, GADBannerViewDelegate {
    
    static let shared = MainViewController()
    
    @IBOutlet weak var popularGifCollection: UICollectionView!
    @IBOutlet weak var popularStickerCollection: UICollectionView!
    @IBOutlet weak var titleIImageGif: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var randomTitleLabel: UILabel!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    @IBOutlet weak var reloadImageTitle: UIButton!
    
    var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadIndicator.startAnimating()
        randomTitleLabel.isHidden = true
        
        setGadBanner()
        setTitleImage()
        
        backImage.image = UIImage.gifImageWithName("back")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        popularGifCollection.reloadData()
        popularStickerCollection.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateContent(notification:)), name: NSNotification.Name(rawValue: "updateContent"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateImageTitle(notification:)), name: NSNotification.Name(rawValue: "updateImageTitle"), object: nil)
    }
    
    @objc func updateContent(notification: NSNotification) {
        DispatchQueue.main.async { [weak self] in
            self?.popularGifCollection.reloadData()
            self?.popularStickerCollection.reloadData()
        }
    }
    
    @objc func updateImageTitle(notification: NSNotification) {
        DispatchQueue.main.async { [weak self] in
            self?.randomTitleLabel.text = "#" + randomTitle
            self?.loadIndicator.stopAnimating()
            self?.randomTitleLabel.isHidden = false
            self?.titleIImageGif.image = UIImage.gifImageWithData(randomDataGif)
        }
    }
    
    func setTitleImage() {
        titleIImageGif.layer.cornerRadius = 5
        titleIImageGif.clipsToBounds = true
        titleIImageGif.image = UIImage.gifImageWithData(randomDataGif)
    }
    
    @IBAction func reloadImageTitleAction(_ sender: UIButton) {
        StartViewController.shared.getRandomGif()
    }
    
    @IBAction func openSearchAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "searchVC") as! SearchViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
    
    @IBAction func seeAll(_ sender: UIButton) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        let vc = storyboard?.instantiateViewController(withIdentifier: "allPopularVC") as! AllPopularViewController
        if sender.restorationIdentifier == "gif" {
            currentCollection = arrayPopularGifData
        } else if sender.restorationIdentifier == "sticker" {
            currentCollection = arrayPopularStickerData
        }
        view.window!.layer.add(transition, forKey: kCATransition)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
    
    @IBAction func selectTag(_ sender: UIButton) {
        var tagText = (sender.titleLabel?.text)!
        inputSearchText = tagText
        tagText.removeFirst()
        
        let searchTag: String = tagText
        let metod: String = "https://"
        let endPointSearchGif: String = "api.giphy.com/v1/gifs/search?"
        let apiKey: String = "wR3NVODE5rYFwyFQJJH38Vvr8Ts73ufz"
        let countGif = "50"
        let rating = "G"
        let language = "en"
        
        let requestURLGIF = metod + endPointSearchGif + "api_key=" + apiKey + "&q=" + searchTag + "&limit=" + countGif + "&offset=0&rating=" + rating + "&lang=" + language
        
        ApiSearch.shared.searchData(requestURL: requestURLGIF)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "searchVC") as! SearchViewController
        vc.typeSearch = "tag"
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
}

//MARK: Set Collection
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == popularGifCollection {
            return arrayPopularGifData.count
        }
        if collectionView == popularStickerCollection {
            return arrayPopularStickerData.count
        }
        return Int()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == popularGifCollection && !arrayPopularGifData.isEmpty {
            let gifCell = collectionView.dequeueReusableCell(withReuseIdentifier: "gifCell", for: indexPath) as! PopularGifCollectionViewCell
            gifCell.imageForGIF.layer.cornerRadius = 5
            gifCell.imageForGIF.clipsToBounds = true
            gifCell.imageForGIF.image = UIImage.gifImageWithData(arrayPopularGifData[indexPath.row])
            return gifCell
        }
        if collectionView == popularStickerCollection && !arrayPopularStickerData.isEmpty {
            let stickerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "stickerCell", for: indexPath) as! PopularStickerCollectionViewCell
            stickerCell.imageForSticker.image = UIImage.gifImageWithData(arrayPopularStickerData[indexPath.row])
            return stickerCell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if !arrayPopularGifData.isEmpty && !arrayPopularStickerData.isEmpty {
            var image = UIImage()
            var newWidthImage = CGFloat()
            if collectionView == self.popularGifCollection {
                image = UIImage.gifImageWithData(arrayPopularGifData[indexPath.row])!
                } else if collectionView == self.popularStickerCollection {
                image = UIImage.gifImageWithData(arrayPopularStickerData[indexPath.row])!
            }
            let ratio: CGFloat = (image.size.width) / (image.size.height)
            newWidthImage = 120 * ratio
            return CGSize(width: newWidthImage, height: 120)
        }
        return CGSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        let vc = storyboard?.instantiateViewController(withIdentifier: "detailVC") as! DetailViewController
        vc.currentIndex = indexPath.row
        vc.nameCurrentCollection = collectionView.restorationIdentifier!
        view.window!.layer.add(transition, forKey: kCATransition)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
}
