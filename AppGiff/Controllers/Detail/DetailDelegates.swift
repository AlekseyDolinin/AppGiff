import UIKit

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayLinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let detailCell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailCell", for: indexPath) as! DetailCollectionViewCell
        let link: String = arrayLinks[indexPath.row]
        
        if arrayFavoritesURL.contains(arrayLinks[indexPath.row]) {
            print(1)
            detailCell.buttonAddInFavorites.setImage(UIImage(named: "iconLikePink"), for: .normal)
        } else {
            print(2)
            detailCell.buttonAddInFavorites.setImage(UIImage(named: "iconDontLikePink"), for: .normal)
        }
        
        if Array(Storage.storage.keys).contains(link) {
            detailCell.imageGif.image = UIImage.gifImageWithData(Storage.storage[link]!)
        } else {
            Api.shared.loadData(urlString: link) { (dataImage) in
                let image: UIImage = UIImage.gifImageWithData(dataImage)!
                detailCell.imageGif.image = image
                Storage.storage[link] = dataImage
            }
        }
        

        
        return detailCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let value = collectionView.frame.size.width / 2 - 12
        return CGSize(width: value, height: value)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DetailViewController.linkCurrentImage = arrayLinks[indexPath.row]
        detailView.updateTopImage()
    }
    
    // HeaderView
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerViewCell", for: indexPath) as? HeaderView else {
            fatalError("Invalid view type")
        }
        headerView.imgView.image = UIImage.gifImageWithData(Storage.storage[DetailViewController.linkCurrentImage]!)
        
        if arrayFavoritesURL.contains(DetailViewController.linkCurrentImage) {
            headerView.favoriteButton.setImage(UIImage(named: "iconLikePink"), for: .normal)
        } else {
            headerView.favoriteButton.setImage(UIImage(named: "iconDontLikePink"), for: .normal)
        }
        
        headerView.sendButton.addTarget(self, action: #selector(sendGifAction), for: .touchUpInside)
        return headerView
    }
    
    // Height Header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let image = UIImage.gifImageWithData(Storage.storage[DetailViewController.linkCurrentImage]!)
        let ratio: CGFloat = (image?.size.width)! / (image?.size.height)!
        let newWidthImage = self.view.frame.width - 16
        let newHeightImage = newWidthImage / ratio
        return CGSize(width: newWidthImage, height: newHeightImage + 116)
    }
}
