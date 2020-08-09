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
            if Array(Storage.storage.keys).contains(link) {
                gifCell.imageForGIF.image = UIImage.gifImageWithData(Storage.storage[link]!)
            } else {
                Api.shared.loadData(urlString: link) { (dataImage) in
                    let image: UIImage = UIImage.gifImageWithData(dataImage)!
                    gifCell.imageForGIF.image = image
                    Storage.storage[link] = dataImage
                }
            }
            return gifCell
        }
        
        if collectionView == mainView.popularStickerCollection {
            let stickerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "stickerCell", for: indexPath) as! PopularCollectionViewCell
            let link: String = arrayPopularStickersLinks[indexPath.row]
            if Array(Storage.storage.keys).contains(link) {
                stickerCell.imageForGIF.image = UIImage.gifImageWithData(Storage.storage[link]!)
            } else {
                Api.shared.loadData(urlString: link) { (dataImage) in
                    let image: UIImage = UIImage.gifImageWithData(dataImage)!
                    stickerCell.imageForGIF.image = image
                    Storage.storage[link] = dataImage
                }
            }
            return stickerCell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "detailVC") as! DetailViewController
        if collectionView == mainView.popularGifCollection {
            vc.linkCurrentImage = arrayPopularGifsLinks[indexPath.row]
            vc.arrayLinks = arrayPopularGifsLinks
            
        } else if collectionView == mainView.popularStickerCollection {
            vc.linkCurrentImage = arrayPopularStickersLinks[indexPath.row]
            vc.arrayLinks = arrayPopularStickersLinks
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}



