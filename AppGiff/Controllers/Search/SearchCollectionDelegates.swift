import UIKit

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayAllGifsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let searchCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as! SearchCell
        
        print("\(arrayAllGifsData.count)==\(indexPath.row)")
        
        searchCell.gifData = arrayAllGifsData[indexPath.row]
        searchCell.buttonAddInFavorites.tag = indexPath.row
        searchCell.setCell()
        
        //подзагрузка
        if indexPath.row == arrayAllGifsData.count - 1 { // last cell
            if totalCountSearchGif > arrayAllGifsData.count { // more items to fetch
                offset = offset + 10
                searchRequest(offset: offset)
            }
        }
        return searchCell
    }
    
    ///
    func collectionView(collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        let image = UIImage.gifImageWithData(arrayAllGifsData[indexPath.row].dataImage) ?? UIImage()
        return image.height(forWidth: withWidth)
    }
    
    ///
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        return CGFloat()
    }
    
    ///
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailTVC") as! DetailTableViewController
        let storiesVC = StoriesNavigationController()
        storiesVC.setup(viewController: vc, previewFrame: collectionView.cellForItem(at: indexPath) as? PreviewStoryViewProtocol)
        vc.dataGif = arrayAllGifsData[indexPath.row].dataImage
        vc.modalPresentationStyle = .fullScreen
        present(storiesVC, animated: true, completion: nil)
    }
    
}
