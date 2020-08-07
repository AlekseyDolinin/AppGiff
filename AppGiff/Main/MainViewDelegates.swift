import UIKit

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func configureCollection() {
        mainView.popularGifCollection.delegate = self
        mainView.popularGifCollection.dataSource = self
        
        mainView.popularStickerCollection.delegate = self
        mainView.popularStickerCollection.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainView.popularGifCollection {
            return arrayPopularGifsLinks.count
        } else if collectionView == mainView.popularStickerCollection {
            return arrayPopularStickersLinks.count
        }
        return Int()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == mainView.popularGifCollection {
            let gifCell = collectionView.dequeueReusableCell(withReuseIdentifier: "gifCell", for: indexPath) as! PopularCollectionViewCell
            //если нашлась data в кэше
            if let dataImage = imageCachData.object(forKey: arrayPopularGifsLinks[indexPath.row] as NSString) {
                gifCell.imageForGIF.image = UIImage.gifImageWithData(dataImage as Data)
            } else {
                //если не нашлась data в кэше
                //скачиваем по ссылке
                ApiRandom.shared.loadData(urlString: arrayPopularGifsLinks[indexPath.row]) { [weak self] (dataImage) in
                    // кэширование data
                    self?.imageCachData.setObject(dataImage as NSData, forKey: (self?.arrayPopularGifsLinks[indexPath.row])! as NSString)
                    gifCell.imageForGIF.image = UIImage.gifImageWithData(dataImage)
                    self?.mainView.popularGifCollection.reloadData()
                }
            }
            return gifCell
        }
        
        if collectionView == mainView.popularStickerCollection {
            let stickerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "stickerCell", for: indexPath) as! PopularCollectionViewCell
            //если нашлась data в кэше
            if let dataImage = imageCachData.object(forKey: arrayPopularStickersLinks[indexPath.row] as NSString) {
                stickerCell.imageForGIF.image = UIImage.gifImageWithData(dataImage as Data)
            } else {
                //если не нашлась data в кэше
                //скачиваем по ссылке
                ApiRandom.shared.loadData(urlString: arrayPopularStickersLinks[indexPath.row]) { [weak self] (dataImage) in
                    // кэширование data
                    self?.imageCachData.setObject(dataImage as NSData, forKey: (self?.arrayPopularStickersLinks[indexPath.row])! as NSString)
                    stickerCell.imageForGIF.image = UIImage.gifImageWithData(dataImage)
                    self?.mainView.popularStickerCollection.reloadData()
                }
            }
            return stickerCell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let dataImage = imageCachData.object(forKey: arrayPopularGifsLinks[indexPath.row] as NSString) {
            let imageGIF = UIImage.gifImageWithData(dataImage as Data)
            let ratio: CGFloat = ((imageGIF?.size.width)!) / ((imageGIF?.size.height)!)
            return CGSize(width: 120 * ratio, height: 120)
        }
        return CGSize()
    }
    
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        let transition = CATransition()
    //        transition.duration = 0.3
    //        transition.type = CATransitionType.push
    //        transition.subtype = CATransitionSubtype.fromRight
    //        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
    //        let vc = storyboard?.instantiateViewController(withIdentifier: "detailVC") as! DetailViewController
    //        vc.currentIndex = indexPath.row
    //        vc.nameCurrentCollection = collectionView.restorationIdentifier!
    //        view.window!.layer.add(transition, forKey: kCATransition)
    //        vc.modalPresentationStyle = .fullScreen
    //        present(vc, animated: false, completion: nil)
    //    }
}
