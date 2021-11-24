import UIKit
import GoogleMobileAds
import AVKit
import AVFoundation

class DetailTableViewController: UITableViewController, GADBannerViewDelegate, GADInterstitialDelegate {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var headerView: UIView!
    
    var dataGif: Data? = nil
    var linkVideo: String!
    
    var bannerView: GADBannerView!
    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        shareButton.layer.cornerRadius = 8
        shareButton.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        
        let imageGif = UIImage.gifImageWithData(dataGif!)
        
        imageView.image = imageGif
        let ratio: CGFloat = (imageGif?.size.width)! / (imageGif?.size.height)!
        let newWidthImage = self.view.frame.width - 48
        let newHeightImage = newWidthImage / ratio
        headerView.frame.size.height = newHeightImage + 93
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if StoreManager.removeAD() == false {
            setGadBanner()
            setGadFullView()
        }
    }

    func showControllerShare() {
        if let dataGifForSend = dataGif {
            let shareController = UIActivityViewController(activityItems: [dataGifForSend], applicationActivities: nil)
            shareController.completionWithItemsHandler = {_, bool, _, _ in
                bool == true ? print("it is done!") : print("error send")
            }
            present(shareController, animated: true, completion: nil)
        }
    }
    
    func getVideo(){
        let player = AVPlayer(url: URL(string: linkVideo)!)
        let vc = AVPlayerViewController()
        vc.player = player
        present(vc, animated: true) {
            vc.player?.play()
        }
    }
    
    @IBAction func doneAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendGifAction() {
        if StoreManager.removeAD() == false {
            /// проверка готов ли рекламный ролик
            interstitial.isReady == true ? interstitial.present(fromRootViewController: self) : showControllerShare()
        } else {
            showControllerShare()
        }
    }
}

extension DetailTableViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -160 {
            doneAction(UIButton())
        }
    }
}
