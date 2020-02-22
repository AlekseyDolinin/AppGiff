import UIKit

class AllPopularViewController: UIViewController, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UITabBarDelegate  {

    static let shared = AllPopularViewController()

    @IBOutlet weak var allPopularCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backImage: UIImageView!
    
    var currentCollection = [Data]()
    let transition = CATransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backImage.image = UIImage.gifImageWithName("back")
        
        if currentCollection == arrayTrandingGifData {
            titleLabel.text = "Popular GIF"
        } else if currentCollection == arrayTrandingStickerData {
            titleLabel.text = "Popular Stickers"
        }
        
        if let layout = allPopularCollectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        allPopularCollectionView.contentInset = UIEdgeInsets(top: 76, left: 8, bottom: 70, right: 8)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }

    
}

//MARK: Flow layout delegate
extension AllPopularViewController: PinterestLayoutDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let image = UIImage.gifImageWithData(currentCollection[indexPath.row])
        let ratio: CGFloat = (image!.size.width) / (image!.size.height)
        let newWidthImage = allPopularCollectionView.frame.width / 2 - 24
        let newHeightImage = newWidthImage / ratio
        return newHeightImage
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let allCell = collectionView.dequeueReusableCell(withReuseIdentifier: "allCell", for: indexPath) as! AllPopularCollectionViewCell
        allCell.imageGif.image = UIImage.gifImageWithData(currentCollection[indexPath.row])
        return allCell
    }
}
