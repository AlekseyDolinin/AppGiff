import UIKit
import SwiftyJSON
import Alamofire



class Api {
    
    static let shared = Api()
    
    let host = "https://api.giphy.com/v1/"
    let api_key = "XTqrUYSYlYYjsLWOoTXJY6mB3DjA8D8n"
    
    /// Random
    func getDataRndGif(randomTitle: String, language: String, completion: @escaping (Data) -> ()) {
        
        let checkingText = randomTitle.alphanumeric
        let stringURL = (host + "gifs/random?api_key=\(api_key)&tag=\(checkingText)&rating=G&lang=\(language)").encodeUrl()
        
        loadJSON(urlString: stringURL!) { (json) in
            if let stringUrl = (json["data"]["images"]["fixed_width_downsampled"]["url"].string) {
                self.loadData(urlString: stringUrl, completion: { (dataGif) in
                    completion(dataGif)
                })
            }
        }
    }
    
    ///
    func loadTrending(typeContent: String, completion: @escaping ([String]) -> ()) {
        let urlGifs = host + "\(typeContent)/trending?api_key=\(api_key)&limit=\(100)&rating=G"
        loadJSON(urlString: urlGifs) { (json) in
            let arrayUrls = json["data"].arrayValue.map({$0["images"]["fixed_width_downsampled"]["url"].string!})
            completion(arrayUrls)
        }
    }
    
    /// Search
    func search(searchText: String, typeContent: TypeContent, language: String, offset: Int, completion: @escaping (JSON) -> ()) {
        
        let checkingText = searchText.alphanumeric
        let stringURL = (host + "\(typeContent)/search?api_key=\(api_key)&q=\(checkingText)&limit=10&offset=\(offset)&rating=G&lang=\(language)").encodeUrl()
        
        request(stringURL!, method: .get).debugLog().LogRequest().responseJSON { response in
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
    
    /// похожие теги
    func searchSuggestions(searchText: String, language: String, completion: @escaping (JSON) -> ()) {
        
        let checkingText = searchText.alphanumeric
        let stringURL = (host + "tags/related/\(checkingText)?api_key=\(api_key)&lang=\(language)").encodeUrl()
        
        request(stringURL!, method: .get).debugLog().LogRequest().responseJSON { response in
            if response.result.isSuccess == false {
                print("ERROR GET JSON searchSuggestions")
                return
            } else {
                if let data = response.data {
                    let json = JSON(data)
                    completion(json)
                }
            }
        }
    }
    
    /// список самых популярных поисковых запросов
    func getTrendingSearch(language: String, completion: @escaping (JSON) -> ()) {
        
        let stringURL = (host + "trending/searches?api_key=\(api_key)&lang=\(language)").encodeUrl()
        
        request(stringURL!, method: .get).debugLog().LogRequest().responseJSON { response in
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
    
    ///
    func loadJSON(urlString: String, completion: @escaping (JSON) -> ()) {
        request(urlString).debugLog().LogRequest().responseData { response in
            if response.error != nil {return}
            let json = JSON(response.value as Any)
            completion(json)
        }
    }

    ///
    func loadData(urlString: String, completion: @escaping (Data) -> ()) {
        request(urlString).debugLog().LogRequest().responseData { response in
            if response.error != nil {return}
            completion(response.data!)
        }
    }
}
