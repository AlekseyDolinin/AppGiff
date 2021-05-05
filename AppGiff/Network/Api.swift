import UIKit
import SwiftyJSON
import Alamofire

class Api {
    
    static let shared = Api()
    
    let link = "https://api.giphy.com/v1/"
    let api_key = "?api_key=wR3NVODE5rYFwyFQJJH38Vvr8Ts73ufz"
    
    func getDataRndGif(randomTitle: String, completion: @escaping (Data) -> ()) {
        let stringURL = link + "gifs/random" + api_key + "&tag=\(randomTitle)&rating=G"
        loadJSON(urlString: stringURL) { (json) in
//            print(json)
            if let stringUrl = (json["data"]["images"]["fixed_width_downsampled"]["url"].string) {
                self.loadData(urlString: stringUrl, completion: { (dataGif) in
                    completion(dataGif)
                })
            }
        }
    }
    
    
    func search(searchText: String, typeContent: TypeContent, offset: Int, completion: @escaping (JSON) -> ()) {
        
        let request = "https://api.giphy.com/v1/\(typeContent)/search?api_key=XTqrUYSYlYYjsLWOoTXJY6mB3DjA8D8n&q=\(searchText)&limit=10&offset=\(offset)&rating=G&lang=en"
        
        Alamofire.request(request, method: .get).responseJSON { response in
            if response.result.isSuccess == false {
                print("ERROR GET JSON Pagination")
                return
            } else {
                if let data = response.data {
                    let json = JSON(data)
                    completion(json)
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
        let urlGifs = "https://api.giphy.com/v1/gifs/trending?api_key=wR3NVODE5rYFwyFQJJH38Vvr8Ts73ufz&limit=\(100)&rating=G"
        loadJSON(urlString: urlGifs) { (json) in
            let arrayUrls = json["data"].arrayValue.map({$0["images"]["fixed_width_downsampled"]["url"].string!})
            completion(arrayUrls)
        }
    }
    
    func loadTrendingStickers(completion: @escaping ([String]) -> ()) {
        let urlStickers = "https://api.giphy.com/v1/stickers/trending?api_key=wR3NVODE5rYFwyFQJJH38Vvr8Ts73ufz&limit=\(100)&rating=G"
        loadJSON(urlString: urlStickers) { (json) in
            let arrayUrls = json["data"].arrayValue.map({$0["images"]["fixed_width_downsampled"]["url"].string!})
            completion(arrayUrls)
        }
    }
}
