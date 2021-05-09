import UIKit
import SwiftyJSON

extension SearchViewController {
    
    func searchRequest(offset: Int) {
        searchView.loader.startAnimating()
        
        let searchTextForSearch = self.searchText.removeWhitespace()

        print("searchTextForSearch: \(searchTextForSearch)")
        Api.shared.search(searchText: searchTextForSearch, typeContent: typeContent, offset: offset) { (json) in
            /// обработка пришедших данных по поиску
            self.completionHandlerSearch(json: json, completion: { (arrayGifsOffSet) in
                self.searchView.loader.stopAnimating()
                self.arrayAllGifsData += arrayGifsOffSet
                self.searchView.searchCollectionView.reloadData()
            })
        }
        
        Api.shared.searchSuggestions(searchText: searchTextForSearch) { (json) in
            print(json)
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
}




//extension SearchViewController {
//
//    func completionHandlerChannel(json: JSON, completion: @escaping ([Channel]) -> ()) {
//        print("всего найдено каналов: \(json["pagination"]["total_count"].intValue)")
//        var arrayChannels: [Channel] = []
//        let dataChannels = json["data"]
//        if dataChannels.isEmpty {
//            print("НИЧЕГО НЕ НАЙДЕНО")
//        }
//
//        for i in dataChannels {
//            let data = i.1
//
//            print(data["type"])
//            print(data["featured_gif"]["images"]["fixed_width_downsampled"]["url"].stringValue)
//
//
//            Api().loadData(urlString: data["type"]["featured_gif"]["images"]["fixed_width_downsampled"]["url"].stringValue) { (dataGif) in
//                let channel = Channel(id: data["id"].stringValue,
//                                      type: data["type"].stringValue,
//                                      linkImage: data["type"]["featured_gif"]["images"]["fixed_width_downsampled"]["url"].stringValue,
//                                      dataImage: dataGif)
//                arrayChannels.append(channel)
//                if arrayChannels.count == data.count {
//                    completion(arrayChannels)
//                }
//            }
//        }
//    }
//
//}
