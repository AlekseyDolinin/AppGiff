import UIKit

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == searchView.searchCollectionView {
            return arrayAllGifsData.count
        } else if collectionView == searchView.tagsCollectionView {
            return arrayTags.count
        }
        return Int()
    }
    
    ///
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == searchView.searchCollectionView {
            let searchCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as! GifCell
            searchCell.imageGif.image = UIImage.gifImageWithData(arrayAllGifsData[indexPath.row].dataImage )
            let link: String = arrayAllGifsData[indexPath.row].linkImage
            if SearchViewController.arrayFavoritesLink.contains(link) {
                searchCell.buttonAddInFavorites.setImage(UIImage(named: "iconLikePink"), for: .normal)
            } else {
                searchCell.buttonAddInFavorites.setImage(UIImage(named: "iconDontLikePink"), for: .normal)
            }
            searchCell.buttonAddInFavorites.tag = indexPath.row
            searchCell.buttonAddInFavorites.addTarget(self, action: #selector(favoriteAction), for: .touchUpInside)
            /// подзагрузка
            if indexPath.row == arrayAllGifsData.count - 1 {
                if totalCountSearchGif > arrayAllGifsData.count {
                    offset = offset + 10
                    searchRequest(offset: offset)
                }
            }
            return searchCell
            
        } else if collectionView == searchView.tagsCollectionView {
            if let tagCell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.reuseIdentifier, for: indexPath) as? TagCell {
                tagCell.tagLabel.text = "#\(arrayTags[indexPath.row])"
                return tagCell
            }
        }
        
        return UICollectionViewCell()
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let cell: TagCell = Bundle.main.loadNibNamed(TagCell.nibName, owner: self, options: nil)?.first as? TagCell else {
            return CGSize.zero
        }
        cell.setCell(textTag: arrayTags[indexPath.row])
        let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        return CGSize(width: size.width, height: 40)
    }
    
    ///
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == searchView.searchCollectionView {
            let vc = storyboard?.instantiateViewController(withIdentifier: "DetailTVC") as! DetailTableViewController
            let storiesVC = StoriesNavigationController()
            storiesVC.setup(viewController: vc, previewFrame: collectionView.cellForItem(at: indexPath) as? PreviewStoryViewProtocol)
            vc.dataGif = arrayAllGifsData[indexPath.row].dataImage
            vc.modalPresentationStyle = .fullScreen
            present(storiesVC, animated: true, completion: nil)
        }
        
        if collectionView == searchView.tagsCollectionView {

            print(arrayTags[indexPath.row])
            let selectTag = arrayTags[indexPath.row]
            self.searchText = selectTag
            searchView.searchText = selectTag
            search()
            searchView.configure()
        }
    }
}
