import UIKit

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayLinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let detailCell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailCell", for: indexPath) as! DetailCollectionViewCell
        let link: String = arrayLinks[indexPath.row]
        if Array(storage.keys).contains(link) {
            detailCell.imageGif.image = UIImage.gifImageWithData(storage[link]!)
        } else {
            Api.shared.loadData(urlString: link) { (dataImage) in
                let image: UIImage = UIImage.gifImageWithData(dataImage)!
                detailCell.imageGif.image = image
                storage[link] = dataImage
            }
        }
        return detailCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let value = collectionView.frame.size.width / 2 - 12
        return CGSize(width: value, height: value)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        linkCurrentImage = arrayLinks[indexPath.row]
        detailView.updateTopImage()
    }
    
    // HeaderView
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerViewCell", for: indexPath) as? HeaderView else {
            fatalError("Invalid view type")
        }
        headerView.imgView.image = UIImage.gifImageWithData(storage[linkCurrentImage]!)
        headerView.sendButton.addTarget(self, action: #selector(sendGifAction), for: .touchUpInside)
        return headerView
    }
    
    // Height Header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let image = UIImage.gifImageWithData(storage[linkCurrentImage]!)
        let ratio: CGFloat = (image?.size.width)! / (image?.size.height)!
        let newWidthImage = self.view.frame.width - 16
        let newHeightImage = newWidthImage / ratio
        return CGSize(width: newWidthImage, height: newHeightImage + 200)
    }
}
