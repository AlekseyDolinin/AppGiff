//import UIKit
//
//class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
//
//    static let shared = HomeViewController()
//    
//    @IBOutlet weak var homeTableView: UITableView!
//    
//    let headesCell: [String] = ["Popular GIF", "Popular Stickers", "Any"]
//    
//    var indexTableCell = 0
//    
//    var arrayCurrentData = [Data]()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//    }
//    
//    @objc func seeAllPopularGifAction() {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "allPopularVC") as! AllPopularViewController
//        vc.currentCollection = arrayTrandingGifData
//        vc.modalPresentationStyle = .fullScreen
//        present(vc, animated: true, completion: nil)
//    }
//    
//    @objc func seeAllPopularStickerAction() {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "allPopularVC") as! AllPopularViewController
//        vc.currentCollection = arrayTrandingStickerData
//        vc.modalPresentationStyle = .fullScreen
//        present(vc, animated: true, completion: nil)
//    }
//    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
//}
//
//extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 2
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let homeCellGif = tableView.dequeueReusableCell(withIdentifier: "homeCellGif", for: indexPath) as! HomeTableViewCell
//        let homeCellSticker = tableView.dequeueReusableCell(withIdentifier: "homeCellSticker", for: indexPath) as! HomeTableViewCell
//        
//        homeCellGif.headerCellTable.text = "Popular GIF"
//        homeCellSticker.headerCellTable.text = "Popular Stickers"
//        
//        homeCellGif.seeAllPopularGif.addTarget(self, action: #selector(seeAllPopularGifAction), for: .touchUpInside)
//        homeCellSticker.seeAllPopularSticker.addTarget(self, action: #selector(seeAllPopularStickerAction), for: .touchUpInside)
//        
//        if indexPath.row == 0 {
//            homeCellGif.homeGifCollectionView.accessibilityIdentifier = "Gif"
//            return homeCellGif
//        } else if indexPath.row == 1 {
//            homeCellSticker.homeGifCollectionView.accessibilityIdentifier = "Sticker"
//            return homeCellSticker
//        }
//        return UITableViewCell()
//    }
//}
//
//extension HomeViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return arrayTrandingGifData.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        let gifHomeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "gifHomeCell", for: indexPath) as! GifHomeCollectionViewCell
//        if collectionView.accessibilityIdentifier == "Gif" {
//            gifHomeCell.imageGif.image = UIImage.gifImageWithData(arrayTrandingGifData[indexPath.row])
//        } else if collectionView.accessibilityIdentifier == "Sticker" {
//            gifHomeCell.imageGif.image = UIImage.gifImageWithData(arrayTrandingStickerData[indexPath.row])
//        }
//        return gifHomeCell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        var image = UIImage()
//        var newWidthImage = CGFloat()
//        
//        if collectionView.accessibilityIdentifier == "Gif" {
//            image = UIImage.gifImageWithData(arrayTrandingGifData[indexPath.row])!
//            let ratio: CGFloat = (image.size.width) / (image.size.height)
//            newWidthImage = 120 * ratio
//            return CGSize(width: newWidthImage, height: 120)
//        } else if collectionView.accessibilityIdentifier == "Sticker" {
//            image = UIImage.gifImageWithData(arrayTrandingStickerData[indexPath.row])!
//            let ratio: CGFloat = (image.size.width) / (image.size.height)
//            newWidthImage = 80 * ratio
//            return CGSize(width: newWidthImage + 30, height: 80)
//        }
//        return CGSize()
//    }
//}
