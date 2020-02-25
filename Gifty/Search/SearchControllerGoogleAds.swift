import GoogleMobileAds

extension SearchViewController {
    
    func setGadBanner() {
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716" //demo
//        bannerView.adUnitID = "ca-app-pub-8093774413708674/4677789374"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        bannerView.transform = CGAffineTransform(translationX: 0, y: 55)
        self.view.addSubview(bannerView)
        
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        bannerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        bannerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        bannerView.widthAnchor.constraint(equalToConstant: 320).isActive = true
    }
    
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("banner Ads Info: \(String(describing: bannerView.responseInfo))")
        showBannerView()
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
        bannerView.isHidden = true
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
    
    func hideBannerView() {
        print("hideAds")
        UIView.animate(withDuration: 0.2) {
            self.bannerView.transform = CGAffineTransform(translationX: 0, y: 55)
        }
    }
    
    func showBannerView() {
        print("showAds")
        UIView.animate(withDuration: 0.2) {
            self.bannerView.transform = .identity
        }
    }
}
