import UIKit

extension AllPopularViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayPopularLinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let allCell = collectionView.dequeueReusableCell(withReuseIdentifier: "allCell", for: indexPath) as! AllPopularCollectionViewCell
        
        let link: String = arrayPopularLinks[indexPath.row]
        if Array(storage.keys).contains(link) {
            allCell.imageGif.image = storage[link] as? UIImage
        } else {
            Api.shared.loadData(urlString: link) { (dataImage) in
                let image: UIImage = UIImage.gifImageWithData(dataImage)!
                allCell.imageGif.image = image
                storage = [link: image]
            }
        }
        return allCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthCell = collectionView.frame.size.width / 2 - 12
        return CGSize(width: widthCell, height: widthCell)
    }
    
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        let transition = CATransition()
    //        transition.duration = 0.3
    //        transition.type = CATransitionType.push
    //        transition.subtype = CATransitionSubtype.fromRight
    //        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
    //        let vc = storyboard?.instantiateViewController(withIdentifier: "detailVC") as! DetailViewController
    //        vc.currentIndex = indexPath.row
    //        vc.nameCurrentCollection = "popular"
    //        vc.currentData = currentCollection
    //        view.window!.layer.add(transition, forKey: kCATransition)
    //        vc.modalPresentationStyle = .fullScreen
    //        present(vc, animated: false, completion: nil)
    //    }
}


