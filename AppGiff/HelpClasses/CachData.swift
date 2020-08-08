import Foundation

class CachData: NSObject {
    
    static let shared = CachData()
    public var imageCachData = NSCache<NSString, NSData>()
    
}
