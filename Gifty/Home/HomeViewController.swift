import UIKit

class HomeViewController: UIViewController, UITextFieldDelegate {

    static let shared = HomeViewController()
    
    @IBOutlet weak var homeTableView: UITableView!

    @IBOutlet weak var placeholderSaerch: UILabel!
    @IBOutlet weak var inputSearch: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        inputSearch.addTarget(self, action: #selector(HomeViewController.textFieldDidChangeq(_:)), for: UIControl.Event.editingChanged)
        
        
    }
    
//    @objc func textFieldDidChangeq(_ textField: UITextField) {
//
//    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        placeholderSaerch.isHidden = true
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let homeCell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeTableViewCell
        
        
        return homeCell
    }
    
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayTrandingGifData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let gifHomeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "gifHomeCell", for: indexPath) as! GifHomeCollectionViewCell
        gifHomeCell.imageGif.image = UIImage.gifImageWithData(arrayTrandingGifData[indexPath.row])
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
        print("ratio:\(ratio)")
        let newWidthImage = 120 * ratio
        print("newWidthImage:\(newWidthImage)")
        
        return CGSize(width: newWidthImage, height: 120)
    }
    

    
}
