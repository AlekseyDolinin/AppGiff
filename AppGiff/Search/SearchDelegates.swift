import UIKit

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayLinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let searchCell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as! SearchCollectionViewCell
        
        //если нашлась data в кэше
        if let dataImage = CachData.shared.imageCachData.object(forKey: arrayLinks[indexPath.row] as NSString) {
            searchCell.imageGif.image = UIImage.gifImageWithData(dataImage as Data)
        } else {
            //если не нашлась data в кэше
            //скачиваем по ссылке
            Api.shared.loadData(urlString: arrayLinks[indexPath.row]) { [weak self] (dataImage) in
                // кэширование data
                CachData.shared.imageCachData.setObject(dataImage as NSData, forKey: (self?.arrayLinks[indexPath.row])! as NSString)
                searchCell.imageGif.image = UIImage.gifImageWithData(dataImage)
            }
        }
        searchCell.loadIndicator.stopAnimating()
        return searchCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let value = (searchView.searchCollectionView.frame.width - 24) / 2
        return CGSize(width: value, height: value)
    }
    
    //    // Did Select Item
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

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchView.hideCollectionForSearch()
        if searchBar.text != nil {
            searchText = searchBar.text!
            request(searchText: searchText, typeSearch: typeSearch)
        }
    }
}
