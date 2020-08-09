import UIKit

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayLinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let searchCell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as! SearchCollectionViewCell
        
        let link: String = arrayLinks[indexPath.row]
        
        if Array(Storage.storage.keys).contains(link) {
            searchCell.imageGif.image = UIImage.gifImageWithData(Storage.storage[link]!)
        } else {
            Api.shared.loadData(urlString: link) { (dataImage) in
                let image: UIImage = UIImage.gifImageWithData(dataImage)!
                searchCell.imageGif.image = image
                Storage.storage[link] = dataImage
            }
        }
        
        searchCell.loadIndicator.stopAnimating()
        return searchCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let value = (searchView.searchCollectionView.frame.width - 24) / 2
        return CGSize(width: value, height: value)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "detailVC") as! DetailViewController
        vc.linkCurrentImage = arrayLinks[indexPath.row]
        vc.arrayLinks = arrayLinks
        navigationController?.pushViewController(vc, animated: true)
    }
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
        } else {
            searchView.hideAnimateSearch()
        }
    }
}
