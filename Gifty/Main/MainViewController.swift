import UIKit

class MainViewController: UIViewController {
    
    static let shared = MainViewController()
    
    @IBOutlet weak var tagCollection: UICollectionView!
    @IBOutlet weak var popularGifCollection: UICollectionView!
    @IBOutlet weak var popularStickerCollection: UICollectionView!
    @IBOutlet weak var titleIImageGif: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    let popularTag: [String] = ["#thumbs up", "#the bachelor", "#shrug", "#yes", "#no", "#wow", "#mad", "#excited", "#bye", "#happy", "#hello", "#love"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(111111)
        
        if let flowLayout = tagCollection?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        popularGifCollection.reloadData()
        popularStickerCollection.reloadData()
        tagCollection.reloadData()
    }
}

//MARK: Set Collection
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case tagCollection:
            print(popularTag.count)
            return popularTag.count
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
        
        if collectionView == tagCollection {
            let tagCell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as! TagCollectionViewCell
            tagCell.label.text = popularTag[indexPath.row]
            return tagCell
        }
        
        if collectionView == popularGifCollection {
            let gifCell = collectionView.dequeueReusableCell(withReuseIdentifier: "gifCell", for: indexPath) as! PopularGifCollectionViewCell
            gifCell.imageForGIF.layer.cornerRadius = 5
            gifCell.imageForGIF.clipsToBounds = true
            gifCell.imageForGIF.image = UIImage.gifImageWithData(arrayTrandingGifData[indexPath.row])
            return gifCell
        }
        
        if collectionView == popularStickerCollection {
            let stickerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "stickerCell", for: indexPath) as! PopularStickerCollectionViewCell
            stickerCell.imageForSticker.image = UIImage.gifImageWithData(arrayTrandingStickerData[indexPath.row])
            return stickerCell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == tagCollection {
            let tagCell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as! TagCollectionViewCell
            let widthCell = (tagCell.label.text?.count)!
            return CGSize(width: widthCell, height: 36)
        }
    
        var image = UIImage()
        var newWidthImage = CGFloat()
        
        if collectionView == popularGifCollection {
            image = UIImage.gifImageWithData(arrayTrandingGifData[indexPath.row])!
            let ratio: CGFloat = (image.size.width) / (image.size.height)
            newWidthImage = 120 * ratio
            return CGSize(width: newWidthImage, height: 120)
        }
        
        if collectionView == popularStickerCollection {
            image = UIImage.gifImageWithData(arrayTrandingStickerData[indexPath.row])!
            let ratio: CGFloat = (image.size.width) / (image.size.height)
            newWidthImage = 120 * ratio
            return CGSize(width: newWidthImage, height: 120)
        }
        return CGSize()
    }
    
    
    
    
}
