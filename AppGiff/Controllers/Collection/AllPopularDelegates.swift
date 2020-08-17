import UIKit

extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayTrendingLinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let allCell = collectionView.dequeueReusableCell(withReuseIdentifier: "allCell", for: indexPath) as! AllTrendingCollectionViewCell
        
        let link: String = arrayTrendingLinks[indexPath.row]
        if Array(Storage.storage.keys).contains(link) {
            allCell.imageGif.image = UIImage.gifImageWithData(Storage.storage[link]!)
            
        } else {
            Api.shared.loadData(urlString: link) { (dataImage) in
                let image: UIImage = UIImage.gifImageWithData(dataImage)!
                allCell.imageGif.image = image
                Storage.storage[link] = dataImage
            }
        }
        return allCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let value = collectionView.frame.size.width / 2 - 12
        return CGSize(width: value, height: value)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "detailVC") as! DetailViewController
        vc.linkCurrentImage = arrayTrendingLinks[indexPath.row]
        vc.arrayLinks = arrayTrendingLinks
        navigationController?.pushViewController(vc, animated: true)
    }
}

