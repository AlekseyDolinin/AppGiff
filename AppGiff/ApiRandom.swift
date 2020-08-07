import UIKit
import SwiftyJSON
import Alamofire

class ApiRandom {
    
    static let shared = ApiRandom()
    
    let metod = "https://"
    let path = "api.giphy.com/v1/gifs/"
    let endPoint = "search?"
    let apiKey = "wR3NVODE5rYFwyFQJJH38Vvr8Ts73ufz"
    let rating = "&rating=G"
    
    func getDataRndGif(randomTitle: String, completion: @escaping (Data) -> ()) {
        let stringURL = metod + path + "random?api_key=" + apiKey + "&tag=\(randomTitle)" + rating
        loadJSON(urlString: stringURL) { (json) in
            if let stringUrl = (json["data"]["images"]["fixed_width_downsampled"]["url"].string) {
                self.loadData(urlString: stringUrl, completion: { (dataGif) in
                    completion(dataGif)
                })
            }
        }
    }
    
    func search(searchText: String, count: String, type: String, completion: @escaping ([String]) -> ()) {
        let stringURL = metod + "api.giphy.com/v1/\(type)/search?" + "api_key=\(apiKey)" + "&q=" + searchText + "&limit=" + count + "&offset=0&rating=G&lang=en"
        loadJSON(urlString: stringURL) { (json) in
            if json["meta"]["status"].intValue != 200 {
                return
            }
            var arrayLinks = [String]()
            for i in 0...Int(count)! - 1 {
                let link: String = json["data"][i]["images"]["fixed_width_downsampled"]["url"].stringValue
                arrayLinks.append(link)
                completion(arrayLinks)
            }
        }
    }
    
    func loadJSON(urlString: String, completion: @escaping (JSON) -> ()) {
        request(urlString).responseData { response in
            if response.error != nil {
                return
            }
            let json = JSON(response.value as Any)
            completion(json)
        }
    }

    func loadData(urlString: String, completion: @escaping (Data) -> ()) {
        request(urlString).responseData { response in
            if response.error != nil {
                return
            }
            completion(response.data!)
        }
    }
    
    func loadPopularGifs(completion: @escaping ([String]) -> ()) {
        let urlGifs = "https://api.giphy.com/v1/gifs/trending?api_key=wR3NVODE5rYFwyFQJJH38Vvr8Ts73ufz&limit=75&rating=G"
        loadJSON(urlString: urlGifs) { (json) in
            let arrayUrls = json["data"].arrayValue.map({$0["images"]["fixed_width_downsampled"]["url"].string!})
            completion(arrayUrls)
        }
    }
    
    func loadPopularStickers(completion: @escaping ([String]) -> ()) {
        let urlStickers = "https://api.giphy.com/v1/stickers/trending?api_key=wR3NVODE5rYFwyFQJJH38Vvr8Ts73ufz&limit=75&rating=G"
        loadJSON(urlString: urlStickers) { (json) in
            let arrayUrls = json["data"].arrayValue.map({$0["images"]["fixed_width_downsampled"]["url"].string!})
            completion(arrayUrls)
        }
    }
}
