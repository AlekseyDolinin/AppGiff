import UIKit

class AllPopularViewController: UIViewController, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UITabBarDelegate  {

    static let shared = AllPopularViewController()

    @IBOutlet weak var allPopularCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var currentCollection = [Data]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if currentCollection == arrayTrandingGifData {
            titleLabel.text = "Popular GIF"
        } else if currentCollection == arrayTrandingStickerData {
            titleLabel.text = "Popular Stickers"
        }
        
        if let layout = allPopularCollectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        allPopularCollectionView.contentInset = UIEdgeInsets(top: 130, left: 8, bottom: 70, right: 8)
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
        print(currentCollection.count)
        return currentCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let allCell = collectionView.dequeueReusableCell(withReuseIdentifier: "allCell", for: indexPath) as! AllPopularCollectionViewCell
        allCell.imageGif.image = UIImage.gifImageWithData(currentCollection[indexPath.row])
        return allCell
    }
}
