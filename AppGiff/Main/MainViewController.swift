import UIKit
import GoogleMobileAds

class MainViewController: UIViewController, GADBannerViewDelegate {
    
    static let shared = MainViewController()
    
    private var mainView: MainView! {
        guard isViewLoaded else {return nil}
        return (view as! MainView)
    }
    
    var bannerView: GADBannerView!
    var titles = ["#thumbs up", "#the bachelor", "#shrug", "#yes", "#no", "#wow", "#mad", "#excited", "#bye", "#happy", "#hello", "#love"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.configure()
        getRndGif()
        setGadBanner()
    }
    
    func getRndGif() {
        let randomTitle = titles.randomElement()!
        ApiRandom.shared.getDataRndGif(randomTitle: randomTitle) { (data) in
            self.mainView.setTitle(title: randomTitle, randomDataGif: data)
        }
    }
    
    @IBAction func reloadImageTitleAction(_ sender: UIButton) {
        mainView.clearTitleGif()
        getRndGif()
    }
    
    @IBAction func openSearchAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "searchVC") as! SearchViewController
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
        var tagText = (sender.titleLabel?.text)!
        tagText.removeFirst()
        let vc = storyboard?.instantiateViewController(withIdentifier: "searchVC") as! SearchViewController
        vc.searchText = tagText
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
}

//// MARK: - Set table
//extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//        if collectionView == popularGifCollection {
//            return arrayPopularGifData.count
//        }
//        if collectionView == popularStickerCollection {
//            return arrayPopularStickerData.count
//        }
//        return Int()
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if collectionView == popularGifCollection && !arrayPopularGifData.isEmpty {
//            let gifCell = collectionView.dequeueReusableCell(withReuseIdentifier: "gifCell", for: indexPath) as! PopularGifCollectionViewCell
//            gifCell.imageForGIF.layer.cornerRadius = 5
//            gifCell.imageForGIF.clipsToBounds = true
//            gifCell.imageForGIF.image = UIImage.gifImageWithData(arrayPopularGifData[indexPath.row])
//            return gifCell
//        }
//        if collectionView == popularStickerCollection && !arrayPopularStickerData.isEmpty {
//            let stickerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "stickerCell", for: indexPath) as! PopularStickerCollectionViewCell
//            stickerCell.imageForSticker.image = UIImage.gifImageWithData(arrayPopularStickerData[indexPath.row])
//            return stickerCell
//        }
//        return UICollectionViewCell()
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if !arrayPopularGifData.isEmpty && !arrayPopularStickerData.isEmpty {
//            var image = UIImage()
//            var newWidthImage = CGFloat()
//            if collectionView == self.popularGifCollection {
//                image = UIImage.gifImageWithData(arrayPopularGifData[indexPath.row])!
//            } else if collectionView == self.popularStickerCollection {
//                image = UIImage.gifImageWithData(arrayPopularStickerData[indexPath.row])!
//            }
//            let ratio: CGFloat = (image.size.width) / (image.size.height)
//            newWidthImage = 120 * ratio
//            return CGSize(width: newWidthImage, height: 120)
//        }
//        return CGSize()
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let transition = CATransition()
//        transition.duration = 0.3
//        transition.type = CATransitionType.push
//        transition.subtype = CATransitionSubtype.fromRight
//        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
//        let vc = storyboard?.instantiateViewController(withIdentifier: "detailVC") as! DetailViewController
//        vc.currentIndex = indexPath.row
//        vc.nameCurrentCollection = collectionView.restorationIdentifier!
//        view.window!.layer.add(transition, forKey: kCATransition)
//        vc.modalPresentationStyle = .fullScreen
//        present(vc, animated: false, completion: nil)
//    }
//}
