import UIKit
import SwiftyJSON

extension SearchViewController {
    
    func searchRequest(offset: Int) {
        searchView.loader.startAnimating()
        let searchTextForSearch = self.searchText.removeWhitespace()
        Api.shared.search(searchText: searchTextForSearch, typeContent: typeContent, offset: offset) { (json) in
            /// обработка пришедших данных по поиску
            self.completionHandlerSearch(json: json, completion: { (arrayGifsOffSet) in
                self.searchView.loader.stopAnimating()
                self.arrayAllGifsData += arrayGifsOffSet
                self.searchView.searchCollectionView.reloadData()
            })
        }
    }
    
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
    
    /// -----------------------------------------------------------------------------------------
    func searchSuggestions() {
        let searchTextForSearch = self.searchText.removeWhitespace()
        Api.shared.searchSuggestions(searchText: searchTextForSearch) { (json) in
            self.completionHandlerSearchSuggestionsTags(json: json, completion: { (arraySuggestionsTags) in
                print(arraySuggestionsTags)
            })
        }
    }
    
    func completionHandlerSearchSuggestionsTags(json: JSON, completion: @escaping ([String]) -> ()) {
        print("всего найдено похожих тегов: \(String(describing: json["data"].count))")
        var arraySuggestionsTags: [String] = []
        let dataSuggestionsTags = json["data"]
        if arrayAllGifsData.isEmpty {
            print("ПОХОЖИХ ТЕГОВ НЕ НАЙДЕНО")
        }
        for tagJsonData in dataSuggestionsTags {
            let tagString = (tagJsonData.1)["name"].stringValue
            arraySuggestionsTags.append(tagString)
            
            if arraySuggestionsTags.count == dataSuggestionsTags.count {
                completion(arraySuggestionsTags)
            }
        }
    }
}
