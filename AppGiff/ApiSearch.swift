import UIKit
import SwiftyJSON

class ApiSearch {
    
    static let shared = ApiSearch()
    
    let task = URLSession.shared
    
    func searchData(requestURL: String) {
        guard let stringURL = URL(string: requestURL) else { return }
        task.dataTask(with: stringURL) { data, response, error in
            guard let data = data, error == nil else {
                print(error ?? "error")
                return
            }
            do {
                let json = try JSON(data: data)
                let arrayUrlSearchGif = json["data"].arrayValue.map({$0["images"]["fixed_width_downsampled"]["url"].string!})
                arraySearchData = []
                for stringUrl in arrayUrlSearchGif {
                    self.loadImageData(stringUrl: stringUrl)
                }
            } catch {
                print(error)
            }
            }.resume()
    }
    
    func loadImageData(stringUrl: String) {
        guard let url = URL(string: stringUrl) else { return }
        task.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error ?? "error")
                return
            }
            arraySearchData.append(data)
            
            if arraySearchData.count == 50  {
                NotificationCenter.default.post(name: NSNotification.Name("Load"), object: true)
            }
            }.resume()
    }
}
