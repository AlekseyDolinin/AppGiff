import UIKit
import SwiftyJSON
import GoogleMobileAds

class DetailViewController: UIViewController, GADBannerViewDelegate, GADInterstitialDelegate {
    
    static let shared = DetailViewController()
    
    @IBOutlet weak var detailCollectionView: UICollectionView!
    @IBOutlet weak var backImage: UIImageView!
    
    var nameCurrentCollection = String()
    var currentIndex = Int()
    var currentData = [Data]()
    var currentArrayTitles = [String]()
    
    fileprivate let headerID = "headerID"
    
    var curentGIFForSend = Data()
    
    // Рекламные банеры
    var interstitial: GADInterstitial!
    var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGadBanner()
        setGadFullView()
        
        setGestureBack()
        backImage.image = UIImage.gifImageWithName("back")

        if nameCurrentCollection == "PopularGif" {
            currentData = arrayPopularGifData
            currentArrayTitles = arrayTitleGif
        } else if nameCurrentCollection == "PopularSticker" {
            currentData = arrayPopularStickerData
            currentArrayTitles = arrayTitleSticker
        } else if nameCurrentCollection == "Search" {
//            currentData = arraySearchData
        } else if nameCurrentCollection == "popular" {
        }
    }
    
    func setGestureBack() {
        var swipeRight = UISwipeGestureRecognizer()
        swipeRight.direction = .right
        swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(back))
        self.view.addGestureRecognizer(swipeRight)
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
    
    @objc func addToFavoritesAction() {
        print("addToFavorite")
    }
    
    @objc func sendGifAction() {
        print("sendGIF")
        
        if interstitial.isReady == true /*&& countShowFullViewAds % 3 == 0 */{
            print("ролик готов")
            interstitial.present(fromRootViewController: self)
        } else {
            showControllerShare()
        }
    }
    
    func showControllerShare() {
        let shareController = UIActivityViewController(activityItems: [curentGIFForSend], applicationActivities: nil)
        shareController.completionWithItemsHandler = {_, bool, _, _ in
            if bool {
                
                print("it is done!")
            } else {
                print("error send")
            }
        }
        present(shareController, animated: true, completion: nil)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        back()
    }
}

//MARK: Flow layout delegate
extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let image = UIImage.gifImageWithData(currentData[indexPath.row])
        let ratio: CGFloat = (image!.size.width) / (image!.size.height)
        let newWidthImage = self.view.frame.width / 2 - 24
        let newHeightImage = newWidthImage / ratio
        return newHeightImage
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let detailCell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailCell", for: indexPath) as! DetailCollectionViewCell
        detailCell.imageGif.image = UIImage.gifImageWithData(currentData[indexPath.row])
        return detailCell
    }
    
    // HeaderView
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerViewCell", for: indexPath) as? HeaderView else {
                fatalError("Invalid view type")
        }
        
//        headerView.titleLabel.text = currentArrayTitles[currentIndex]

        curentGIFForSend = currentData[currentIndex]
        headerView.imgView.image = UIImage.gifImageWithData(currentData[currentIndex])
        headerView.imgView.layer.cornerRadius = 5
        headerView.imgView.clipsToBounds = true
        
        headerView.sendButton.addTarget(self, action: #selector(sendGifAction), for: .touchUpInside)
        
        return headerView
    }
    
    // Height Header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let image = UIImage.gifImageWithData(currentData[currentIndex])
        let ratio: CGFloat = (image!.size.width) / (image!.size.height)
        let newWidthImage = self.view.frame.width - 16
        let newHeightImage = newWidthImage / ratio
        return CGSize(width: newWidthImage, height: newHeightImage + 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfColums: CGFloat = 2
        let width = collectionView.frame.size.width
        let xInsets: CGFloat = 8
        let cellSpacing: CGFloat = 4
        let image = UIImage.gifImageWithData(currentData[indexPath.row])
        let height: CGFloat = (image?.size.height)!
        let widthColum = (width / numberOfColums) - (xInsets + cellSpacing)

        return CGSize(width: widthColum, height: widthColum * 2 / 3)
        
    }

//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        currentIndex = indexPath.row
//        detailCollectionView.reloadData()
//        UIView.animate(withDuration: 0.3) { [weak self] in
//            self?.detailCollectionView.contentOffset.y = 0
//        }
//    }
}
