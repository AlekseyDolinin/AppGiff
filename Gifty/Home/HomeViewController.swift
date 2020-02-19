import UIKit

class HomeViewController: UIViewController, UITextFieldDelegate {

    static let shared = HomeViewController()
    
    @IBOutlet weak var homeTableView: UITableView!

    @IBOutlet weak var placeholderSaerch: UILabel!
    @IBOutlet weak var inputSearch: UITextField!
    
    
    
    let headesCell: [String] = ["Popular GIF", "Popular Stickers", "Any"]
    
    var indexTableCell = 0
    
    var arrayCurrentData = [Data]()
    
    override func viewDidLoad() {
        super.viewDidLoad()


        
        
    }

    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        placeholderSaerch.isHidden = true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = ""
        placeholderSaerch.isHidden = false
    }
    
    func textFieldDidChange(textField: UITextField) {
        print(22222)
    }
    
    
    
    //    контроль ввода символов в инпуты
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        let search = inputSearch.text?.trimmingCharacters(in: .whitespacesAndNewlines)

        print(search)
        
        return true
    }
    
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


extension HomeViewController: UITabBarDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let homeCell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeTableViewCell
        homeCell.headerCellTable.text = headesCell[indexPath.row]
        
        indexTableCell = indexPath.row
        
        arrayCurrentData = []
        
        homeCell.homeGifCollectionView.accessibilityIdentifier = String(indexPath.row)
        
        if indexPath.row == 0 {
            arrayCurrentData = arrayTrandingGifData
        } else if indexPath.row == 1 {
            arrayCurrentData = arrayTrandingStickerData
        }
        
        return homeCell
    }
    
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayTrandingGifData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let gifHomeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "gifHomeCell", for: indexPath) as! GifHomeCollectionViewCell
        
//        if indexTableCell == 0 {
//            gifHomeCell.imageGif.image = UIImage.gifImageWithData(arrayTrandingGifData[indexPath.row])
//        } else if indexTableCell == 1 {
//            gifHomeCell.imageGif.image = UIImage.gifImageWithData(arrayTrandingStickerData[indexPath.row])
//        }
        
//        print(indexPath)
        gifHomeCell.imageGif.image = UIImage.gifImageWithData(arrayCurrentData[indexPath.row])
        
        return gifHomeCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "allGifVC")
        vc?.modalPresentationStyle = .fullScreen
        present(vc!, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let image = UIImage.gifImageWithData(arrayTrandingGifData[indexPath.row])
        let ratio: CGFloat = (image!.size.width) / (image!.size.height)
//        print("ratio:\(ratio)")
        let newWidthImage = 120 * ratio
//        print("newWidthImage:\(newWidthImage)")
        
        return CGSize(width: newWidthImage, height: 120)
    }
    

    
}
