import UIKit
import SwiftyJSON

class ApiRandom {
    
    static let shared = ApiRandom()
    
    let task = URLSession.shared
    
    func randomData(requestURL: String) {
        guard let stringURL = URL(string: requestURL) else { return }
        task.dataTask(with: stringURL) { data, response, error in
            guard let data = data, error == nil else {
                print(error ?? "error")
                return
            }
            do {
                print("load data random gif for title")
                let json = try JSON(data: data)
                let randomURL = (json["data"]["images"]["fixed_width_downsampled"]["url"].string!)
                self.loadImageData(randomURL: randomURL)
            } catch {
                print(error)
            }
            }.resume()
    }
    
    func loadImageData(randomURL: String) {
        guard let url = URL(string: randomURL) else { return }
        task.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error ?? "error")
                return
            }
            randomDataGif = data
            print("load random gif for title")
            loadRandom = true
            }.resume()
    }
}
