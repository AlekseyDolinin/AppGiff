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


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let homeCellGif = tableView.dequeueReusableCell(withIdentifier: "homeCellGif", for: indexPath) as! HomeTableViewCell
        let homeCellSticker = tableView.dequeueReusableCell(withIdentifier: "homeCellSticker", for: indexPath) as! HomeTableViewCell
        
        homeCellGif.headerCellTable.text = "Popular GIF"
        homeCellSticker.headerCellTable.text = "Popular Stickers"
        
        if indexPath.row == 0 {
            homeCellGif.homeGifCollectionView.accessibilityIdentifier = "Gif"
            return homeCellGif
        } else if indexPath.row == 1 {
            homeCellSticker.homeGifCollectionView.accessibilityIdentifier = "Sticker"
            return homeCellSticker
        }
        return UITableViewCell()
    }
    
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayTrandingGifData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let gifHomeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "gifHomeCell", for: indexPath) as! GifHomeCollectionViewCell
        
        if collectionView.accessibilityIdentifier == "Gif" {
            gifHomeCell.imageGif.image = UIImage.gifImageWithData(arrayTrandingGifData[indexPath.row])
        } else if collectionView.accessibilityIdentifier == "Sticker" {
            gifHomeCell.imageGif.image = UIImage.gifImageWithData(arrayTrandingStickerData[indexPath.row])
        }
        return gifHomeCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "allGifVC")
        vc?.modalPresentationStyle = .fullScreen
        present(vc!, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var image = UIImage()
        if collectionView.accessibilityIdentifier == "Gif" {
            image = UIImage.gifImageWithData(arrayTrandingGifData[indexPath.row])!
        } else if collectionView.accessibilityIdentifier == "Sticker" {
            image = UIImage.gifImageWithData(arrayTrandingStickerData[indexPath.row])!
        }
        let ratio: CGFloat = (image.size.width) / (image.size.height)
        let newWidthImage = 140 * ratio
        return CGSize(width: newWidthImage, height: 140)
    }
    

    
}
