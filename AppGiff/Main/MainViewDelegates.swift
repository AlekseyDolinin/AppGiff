import UIKit

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainView.popularGifCollection {
            return arrayPopularGifsLinks.count
        } else if collectionView == mainView.popularStickerCollection {
            return arrayPopularStickersLinks.count
        }
        return Int()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == mainView.popularGifCollection {
            let gifCell = collectionView.dequeueReusableCell(withReuseIdentifier: "gifCell", for: indexPath) as! PopularCollectionViewCell
            let link: String = arrayPopularGifsLinks[indexPath.row]
            if Array(storage.keys).contains(link) {
                gifCell.imageForGIF.image = storage[link] as? UIImage
            } else {
                Api.shared.loadData(urlString: link) { (dataImage) in
                    let image: UIImage = UIImage.gifImageWithData(dataImage)!
                    gifCell.imageForGIF.image = image
                    storage = [link: image]
                }
            }
            return gifCell
        }
        
        if collectionView == mainView.popularStickerCollection {
            let stickerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "stickerCell", for: indexPath) as! PopularCollectionViewCell
            let link: String = arrayPopularStickersLinks[indexPath.row]
            if Array(storage.keys).contains(link) {
                stickerCell.imageForGIF.image = storage[link] as? UIImage
            } else {
                Api.shared.loadData(urlString: link) { (dataImage) in
                    let image: UIImage = UIImage.gifImageWithData(dataImage)!
                    stickerCell.imageForGIF.image = image
                    storage = [link: image]
                }
            }
            return stickerCell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 120)
    }
    

    
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
}



