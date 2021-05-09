import UIKit

extension SearchViewController: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let inputText = textField.text {
            self.searchText = inputText
            searchTextLanguage = String(((textField.textInputMode?.primaryLanguage)?.prefix(2))!)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search()
        return true
    }
}
