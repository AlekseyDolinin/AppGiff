import UIKit

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchText = textField.text ?? ""
        trimingSearchWord()
    }
    
    
    /// запрос поиска после триминга
    func trimingSearchWord() {
        self.searchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if self.searchText != "" {
            /// скрытие клавиатуры
            view.endEditing(true)
            
            searchRequest(offset: offset)
            
//            if searchText != tempText {
//                searchRequest(offset)
//
//                /// показ лоадера
//                searchView.loadIndicator.startAnimating()
//                clearData()
//            }
        } else {
            print("input empty")
            //            clearData()
        }
    }
}
