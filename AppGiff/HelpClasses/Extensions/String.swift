import UIKit

/// удаление пробелов и спецсимволов
extension String {
    var alphanumeric: String {
        return self.components(separatedBy: CharacterSet.alphanumerics.inverted).joined().lowercased()
    }
}

///
extension String {
    
    func encodeUrl() -> String? {
        return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
    }
    
    func decodeUrl() -> String? {
        return self.removingPercentEncoding
    }
}
