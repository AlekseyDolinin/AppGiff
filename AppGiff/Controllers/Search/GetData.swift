import UIKit
import SwiftyJSON

extension SearchViewController {
    
    func searchRequest(offset: Int) {
        
        print("поиск: \(self.searchText)")
        
        searchView.loader.startAnimating()
        
        Api.shared.search(searchText: self.searchText, typeContent: typeContent, offset: offset) { (json) in
            
            print(json)
            /// обработка пришедших данных
            self.completionHandlerSearch(json: json, completion: { (completion) in
                self.searchView.loader.stopAnimating()
                self.arrayAllGifsData += completion
                self.searchView.searchCollectionView.reloadData()
            })
        }
    }
}

extension SearchViewController {
    
    func completionHandlerSearch(json: JSON, completion: @escaping ([GifImageData]) -> ()) {
        self.totalCountSearchGif = json["pagination"]["total_count"].intValue
        print("всего найдено: \(String(describing: self.totalCountSearchGif))")
        
        var arrayGifsOffSet: [GifImageData] = []
        let dataLinksGifs = json["data"]
        if arrayAllGifsData.isEmpty {
            print("НИЧЕГО НЕ НАЙДЕНО")
        }
        for i in dataLinksGifs {
            let data = i.1
            Api().loadData(urlString: data["images"]["fixed_width_downsampled"]["url"].stringValue) { (dataGif) in
                let imageGIf = GifImageData(id: data["id"].stringValue,
                                        dataImage: dataGif,
                                        linkImage: data["images"]["fixed_width_downsampled"]["url"].stringValue)
                arrayGifsOffSet.append(imageGIf)
                if arrayGifsOffSet.count == dataLinksGifs.count {
                    completion(arrayGifsOffSet)
                }
            }
        }
    }
}
