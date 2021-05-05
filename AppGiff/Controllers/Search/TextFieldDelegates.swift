import UIKit

extension SearchViewController: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let inputText = textField.text {
            self.searchText = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
            print(self.searchText)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search()
        return true
    }
}
