import UIKit

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainView.trendingGifCollection {
            return arrayTrendingGifsLinks.count
        } else if collectionView == mainView.trendingStickerCollection {
            return arrayTrendingStickersLinks.count
        } else if collectionView == mainView.tagCollection {
            return arrayTags.count
        }
        return Int()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == mainView.trendingGifCollection {
            let gifTrendingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendingCell", for: indexPath) as! TrendingCell
            gifTrendingCell.setCell(link: arrayTrendingGifsLinks[indexPath.row])
            return gifTrendingCell
        }
        
        if collectionView == mainView.trendingStickerCollection {
            let stickerTrendingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendingCell", for: indexPath) as! TrendingCell
            stickerTrendingCell.setCell(link: arrayTrendingStickersLinks[indexPath.row])
            return stickerTrendingCell
        }
        
        if collectionView == mainView.tagCollection {
            if let tagCell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.reuseIdentifier, for: indexPath) as? TagCell {
                tagCell.setCell(textTag: arrayTags[indexPath.row])
                return tagCell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == mainView.tagCollection {
            guard let cell: TagCell = Bundle.main.loadNibNamed(TagCell.nibName, owner: self, options: nil)?.first as? TagCell else {
                return CGSize.zero
            }
            cell.setCell(textTag: arrayTags[indexPath.row])
            let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            return CGSize(width: size.width, height: 36)
        }
        return CGSize(width: 120, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        ///
        if collectionView == mainView.trendingGifCollection {
            Api.shared.loadData(urlString: arrayTrendingGifsLinks[indexPath.row], completion: { (data) in
                self.openDetail(dataGif: data)
            })
            ///
        } else if collectionView == mainView.trendingStickerCollection {
            Api.shared.loadData(urlString: arrayTrendingStickersLinks[indexPath.row], completion: { (data) in
                self.openDetail(dataGif: data)
            })
        } else if collectionView == mainView.tagCollection {
            let vc = storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
            vc.searchText = arrayTags[indexPath.row]
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
    
    func openDetail(dataGif: Data) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailTVC") as! DetailTableViewController
        vc.dataGif = dataGif
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}
