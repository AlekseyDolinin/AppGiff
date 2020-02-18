import UIKit

class AllGifViewController: UIViewController, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UITabBarDelegate  {

    static let shared = AllGifViewController()

    @IBOutlet weak var allGifCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = allGifCollectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        allGifCollectionView.contentInset = UIEdgeInsets(top: 150, left: 8, bottom: 70, right: 8)
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

//MARK: Flow layout delegate
extension AllGifViewController: PinterestLayoutDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let image = UIImage.gifImageWithData(arrayTrandingGifData[indexPath.row])
        let ratio: CGFloat = (image!.size.width) / (image!.size.height)
        let newWidthImage = allGifCollectionView.frame.width / 2 - 24
        let newHeightImage = newWidthImage / ratio
        return newHeightImage
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayTrandingGifData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let allCell = collectionView.dequeueReusableCell(withReuseIdentifier: "allCell", for: indexPath) as! AllGifCollectionViewCell
        allCell.imageGif.image = UIImage.gifImageWithData(arrayTrandingGifData[indexPath.row])
        return allCell
    }
    
}
