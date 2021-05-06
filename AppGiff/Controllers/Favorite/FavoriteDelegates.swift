import UIKit

extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayLinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let allCell = collectionView.dequeueReusableCell(withReuseIdentifier: "allCell", for: indexPath) as! AllTrendingCollectionViewCell
        
        let link: String = arrayLinks[indexPath.row]
        
        if StartViewController.arrayFavoritesURL.contains(arrayLinks[indexPath.row]) {
            allCell.favoriteButton.setImage(UIImage(named: "iconLikePink"), for: .normal)
        } else {
            allCell.favoriteButton.setImage(UIImage(named: "iconDontLikePink"), for: .normal)
        }
        
        if Array(Storage.storage.keys).contains(link) {
            allCell.imageGif.image = UIImage.gifImageWithData(Storage.storage[link]!)
            
        } else {
            Api.shared.loadData(urlString: link) { (dataImage) in
                let image: UIImage = UIImage.gifImageWithData(dataImage)!
                allCell.imageGif.image = image
                Storage.storage[link] = dataImage
            }
        }
        
        allCell.favoriteButton.isHidden = true
        
        allCell.favoriteButton.tag = indexPath.row
        allCell.favoriteButton.addTarget(self, action: #selector(favoriteAction), for: .touchUpInside)
        
        return allCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let value = collectionView.frame.size.width / 2 - 12
        return CGSize(width: value, height: value)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        
        
    }
}


