import Foundation

class Storage: NSObject {
    static var storage = [String: Data]()
    
    var storageLinks = UserDefaults.standard.array(forKey: "storageLinks")
    
}
