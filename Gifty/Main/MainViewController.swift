import UIKit

class MainViewController: UIViewController {
    
    static let shared = MainViewController()
    
    @IBOutlet weak var popularGifCollection: UICollectionView!
    @IBOutlet weak var popularStickerCollection: UICollectionView!
    @IBOutlet weak var titleIImageGif: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var backImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backImage.image = UIImage.gifImageWithName("back")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        popularGifCollection.reloadData()
        popularStickerCollection.reloadData()
    }
    
    @IBAction func seeAll(_ sender: UIButton) {
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "allPopularVC") as! AllPopularViewController
        if sender.restorationIdentifier == "gif" {
            vc.currentCollection = arrayTrandingGifData
        } else if sender.restorationIdentifier == "sticker" {
            vc.currentCollection = arrayTrandingStickerData
        }
        
        view.window!.layer.add(transition, forKey: kCATransition)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
    
    @IBAction func selectTag(_ sender: UIButton) {
//        print(sender.titleLabel?.text)
    }
}

//MARK: Set Collection
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case popularGifCollection:
            print(arrayTrandingGifData.count)
            return arrayTrandingGifData.count
        case popularStickerCollection:
            print(arrayTrandingStickerData.count)
            return arrayTrandingStickerData.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == popularGifCollection {
            let gifCell = collectionView.dequeueReusableCell(withReuseIdentifier: "gifCell", for: indexPath) as! PopularGifCollectionViewCell
            gifCell.imageForGIF.layer.cornerRadius = 5
            gifCell.imageForGIF.clipsToBounds = true
            DispatchQueue.main.async {
                gifCell.imageForGIF.image = UIImage.gifImageWithData(arrayTrandingGifData[indexPath.row])
            }
            
            return gifCell
        }
        
        if collectionView == popularStickerCollection {
            let stickerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "stickerCell", for: indexPath) as! PopularStickerCollectionViewCell
            DispatchQueue.main.async {
                stickerCell.imageForSticker.image = UIImage.gifImageWithData(arrayTrandingStickerData[indexPath.row])
            }
            return stickerCell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var image = UIImage()
        var newWidthImage = CGFloat()
        
        if collectionView == popularGifCollection {
//            DispatchQueue.main.async {
                image = UIImage.gifImageWithData(arrayTrandingGifData[indexPath.row])!
//            }
            let ratio: CGFloat = (image.size.width) / (image.size.height)
            newWidthImage = 120 * ratio
            return CGSize(width: newWidthImage, height: 120)
        }
        
        if collectionView == popularStickerCollection {
//            DispatchQueue.main.async {
                image = UIImage.gifImageWithData(arrayTrandingStickerData[indexPath.row])!
//            }
            let ratio: CGFloat = (image.size.width) / (image.size.height)
            newWidthImage = 120 * ratio
            return CGSize(width: newWidthImage, height: 120)
        }
        return CGSize()
    }
}
