//import UIKit
//import SwiftyJSON
//
//class DetailViewController_: UIViewController, UICollectionViewDelegateFlowLayout {
//    
//    static let shared = DetailViewController()
//    
//    @IBOutlet weak var detailCollectionView: UICollectionView!
//    @IBOutlet weak var backImage: UIImageView!
//    @IBOutlet weak var titleImage: UIImageView!
//    @IBOutlet weak var constrHeightTitleImage: NSLayoutConstraint!
//    @IBOutlet weak var constrHeightCollection: NSLayoutConstraint!
//    
//    var nameCurrentCollection = String()
//    var currentIndex = Int()
//    var currentData = [Data]()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        
//        
//        setGestureBack()
//        backImage.image = UIImage.gifImageWithName("back")
//        if let layout = detailCollectionView.collectionViewLayout as? PinterestLayout {
//            layout.delegate = self
//        }
//        detailCollectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 70, right: 8)
//        if nameCurrentCollection == "PopularGif" {
//            currentData = arrayPopularGifData
//        } else {
//            currentData = arrayPopularStickerData
//        }
//        setTitleImage()
//    }
//    
//    func setDetailCollectionView() {
//        constrHeightCollection.constant = detailCollectionView.contentSize.height
//        detailCollectionView.reloadData()
//    }
//    
//    func setTitleImage() {
//        titleImage.layer.cornerRadius = 5
//        titleImage.clipsToBounds = true
//        let imageData = currentData[currentIndex]
//        let image = UIImage.gifImageWithData(imageData)
//        let ratio: CGFloat = (image!.size.width) / (image!.size.height)
//        let newWidthImage = self.view.frame.width - 32
//        let newHeightImage = newWidthImage / ratio
//        titleImage.frame.size.width = newWidthImage
//        titleImage.frame.size.height = newHeightImage
//        titleImage.image = image
//        constrHeightTitleImage.constant = newHeightImage
//    }
//    
//    
//    func setGestureBack() {
//        var swipeRight = UISwipeGestureRecognizer()
//        swipeRight.direction = .right
//        swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(back))
//        self.view.addGestureRecognizer(swipeRight)
//    }
//    
//    @objc func back() {
//        let transition = CATransition()
//        transition.duration = 0.3
//        transition.type = CATransitionType.push
//        transition.subtype = CATransitionSubtype.fromLeft
//        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
//        view.window!.layer.add(transition, forKey: kCATransition)
//        dismiss(animated: false, completion: nil)
//    }
//    
//    @IBAction func backAction(_ sender: UIButton) {
//        back()
//    }
//}
//
////MARK: Flow layout delegate
//extension DetailViewController: PinterestLayoutDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
//    
//    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
//        let image = UIImage.gifImageWithData(currentData[indexPath.row])
//        let ratio: CGFloat = (image!.size.width) / (image!.size.height)
//        let newWidthImage = self.view.frame.width / 2 - 24
//        let newHeightImage = newWidthImage / ratio
//        return newHeightImage
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return currentData.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let detailCell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailCell", for: indexPath) as! DetailCollectionViewCell
//        detailCell.imageGif.image = UIImage.gifImageWithData(currentData[indexPath.row])
//        return detailCell
//    }
//    
//}
