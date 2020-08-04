import UIKit
import SwiftyJSON


var arrayPopularGifData = [Data]()
var arrayPopularStickerData = [Data]()

var arrayTitleGif = [String]()
var arrayTitleSticker = [String]()

var randomDataGif = Data()
var randomTitle = ""

var loadRandomGif = Bool()

class API {
    
    static let shared = API()
    
    let task = URLSession.shared
    
    var arrayUrlPopularGif = [String]()
    var arrayUrlPopularSticker = [String]()
    
    let metod: String = "https://"
    let endPointGif: String = "api.giphy.com/v1/gifs/trending"
    let endPointStickers: String = "api.giphy.com/v1/stickers/trending"
    let apiKey: String = "wR3NVODE5rYFwyFQJJH38Vvr8Ts73ufz"
    let countGif = "50"
    let rating = "G"
    
    
    
    //    func getPopular() {
    //        let requestURLGIF = metod + endPointGif + "?api_key=" + apiKey + "&limit=" + countGif + "&rating=" + rating
    //        let requestURLStickers = metod + endPointStickers + "?api_key=" + apiKey + "&limit=" + countGif + "&rating=" + rating
    //        API.shared.loadTrendingGif(requestURL: requestURLGIF)
    //        API.shared.loadTrendingSticker(requestURL: requestURLStickers)
    //    }
    
    func getPopular() {
        
        print("getPopular")
        
        
    }
    
    
    
    
    func loadTrendingGif(requestURL: String) {
        guard let stringURL = URL(string: requestURL) else { return }
        task.dataTask(with: stringURL) { data, response, error in
            guard let data = data, error == nil else {
                print(error ?? "error")
                return
            }
            do {
                let json = try JSON(data: data)
                self.arrayUrlPopularGif = json["data"].arrayValue.map({$0["images"]["fixed_width_downsampled"]["url"].string!})
                arrayTitleGif = json["data"].arrayValue.map({$0["title"].string!})
                for stringUrl in self.arrayUrlPopularGif {
                    self.loadImageData(stringUrl: stringUrl, typeContent: "Gif")
                }
                print("load data popular gif")
            } catch {
                print(error)
            }
            }.resume()
    }
    
    func loadTrendingSticker(requestURL: String) {
        guard let stringURL = URL(string: requestURL) else { return }
        task.dataTask(with: stringURL) { data, response, error in
            guard let data = data, error == nil else {
                print(error ?? "error")
                return
            }
            do {
                let json = try JSON(data: data)
                self.arrayUrlPopularSticker = json["data"].arrayValue.map({$0["images"]["fixed_width_downsampled"]["url"].string!})
                arrayTitleSticker = json["data"].arrayValue.map({$0["title"].string!})
                for stringUrl in self.arrayUrlPopularSticker {
                    self.loadImageData(stringUrl: stringUrl, typeContent: "Sticker")
                }
                print("load data popular stickers")
            } catch {
                print(error)
            }
            }.resume()
    }
    
    func loadImageData(stringUrl: String, typeContent: String) {
        
        if arrayUrlPopularGif.count == 50 && arrayUrlPopularSticker.count == 50 {
            NotificationCenter.default.post(name: NSNotification.Name("Load"), object: true)
        }
        
        guard let url = URL(string: stringUrl) else { return }
        task.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error ?? "error")
                return
            }
            if typeContent == "Sticker" {
                arrayPopularStickerData.append(data)
            } else if typeContent == "Gif" {
                arrayPopularGifData.append(data)
            }
            NotificationCenter.default.post(name: NSNotification.Name("updateContent"), object: true)
            
//            if arrayPopularGifData.count == 15 && arrayPopularStickerData.count == 15 && loadRandomGif == true {
//                NotificationCenter.default.post(name: NSNotification.Name("Load"), object: true)
//            }
            }.resume()
    }
    
    

    
    
}
