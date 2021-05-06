import UIKit

class SearchCell: UICollectionViewCell, PreviewStoryViewProtocol {
    
    @IBOutlet weak var imageGif: UIImageView!
    @IBOutlet weak var buttonAddInFavorites: UIButton!

    public var startFrame: CGRect {
        return convert(bounds, to: nil)
    }

    public var endFrame: CGRect {
        return convert(bounds, to: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        imageGif.layer.cornerRadius = 5
        imageGif.clipsToBounds = true
    }

    var gifData: GifImageData!

    func setCell() {
        setFavorite()
        buttonAddInFavorites.addTarget(self, action: #selector(favoriteAction), for: .touchUpInside)
        imageGif.image = UIImage.gifImageWithData(gifData.dataImage)
    }

    func setFavorite() {
        if StartViewController.arrayFavoritesURL.contains(gifData.linkImage) {
            buttonAddInFavorites.setImage(UIImage(named: "iconLikePink"), for: .normal)
        } else {
            buttonAddInFavorites.setImage(UIImage(named: "iconDontLikePink"), for: .normal)
        }
    }

    /// работа с избранным
    @objc func favoriteAction(sender: UIButton) {

//            /// проверяем есть ли ссылка в избранном
//            let index = MainViewController.arrayFavoritesLink.firstIndex(of: link)
//
//            if index == nil {
//                //ссылки нет в избранном
//                //добавление ссылки в избранное
//                MainViewController.arrayFavoritesLink.append(link)
//            } else {
//                //ссылка есть в избранном
//                //удаление ссылки из избранного
//                MainViewController.arrayFavoritesLink.remove(at: index!)
//            }
//
//            mainView.collectionSearchGifs.reloadData()
//            print(MainViewController.arrayFavoritesLink.count)
//            //запись нового массива с линками
//            UserDefaults.standard.set(MainViewController.arrayFavoritesLink, forKey: "favoritesLinks")
//            UserDefaults.standard.synchronize()
    }
}
