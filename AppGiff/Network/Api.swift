import UIKit
import SwiftyJSON
import Alamofire

class Api {
    
    static let shared = Api()
    let count = 100
    
    func getDataRndGif(randomTitle: String, completion: @escaping (Data) -> ()) {
        let stringURL = "https://api.giphy.com/v1/gifs/random?api_key=wR3NVODE5rYFwyFQJJH38Vvr8Ts73ufz&tag=\(randomTitle)&rating=G"
        loadJSON(urlString: stringURL) { (json) in
//            print(json)
            if let stringUrl = (json["data"]["images"]["fixed_width_downsampled"]["url"].string) {
                self.loadData(urlString: stringUrl, completion: { (dataGif) in
                    completion(dataGif)
                })
            }
        }
    }
    
    func search(searchText: String, type: String, completion: @escaping ([String]) -> ()) {
        var arrayLinks = [String]()
        let stringURL = "https://api.giphy.com/v1/\(type)/search?api_key=wR3NVODE5rYFwyFQJJH38Vvr8Ts73ufz&q=\(searchText)&limit=25&offset=0&rating=G&lang=en"
        loadJSON(urlString: stringURL) { (json) in
            if json["meta"]["status"].intValue != 200 {return}
            if json["pagination"]["total_count"].intValue == 0 {
                completion([])
            } else {
                for i in 0...24 {
                    let link: String = json["data"][i]["images"]["fixed_width_downsampled"]["url"].stringValue
                    arrayLinks.append(link)
                    completion(arrayLinks)
                }
            }
        }
    }
    
    func loadJSON(urlString: String, completion: @escaping (JSON) -> ()) {
        request(urlString).responseData { response in
            if response.error != nil {return}
            let json = JSON(response.value as Any)
            completion(json)
        }
    }

    func loadData(urlString: String, completion: @escaping (Data) -> ()) {
        request(urlString).responseData { response in
            if response.error != nil {return}
            completion(response.data!)
        }
    }
    
    func loadTrendingGifs(completion: @escaping ([String]) -> ()) {
        let urlGifs = "https://api.giphy.com/v1/gifs/trending?api_key=wR3NVODE5rYFwyFQJJH38Vvr8Ts73ufz&limit=\(count)&rating=G"
        loadJSON(urlString: urlGifs) { (json) in
            let arrayUrls = json["data"].arrayValue.map({$0["images"]["fixed_width_downsampled"]["url"].string!})
            completion(arrayUrls)
        }
    }
    
    func loadTrendingStickers(completion: @escaping ([String]) -> ()) {
        let urlStickers = "https://api.giphy.com/v1/stickers/trending?api_key=wR3NVODE5rYFwyFQJJH38Vvr8Ts73ufz&limit=\(count)&rating=G"
        loadJSON(urlString: urlStickers) { (json) in
            let arrayUrls = json["data"].arrayValue.map({$0["images"]["fixed_width_downsampled"]["url"].string!})
            completion(arrayUrls)
        }
    }
}
