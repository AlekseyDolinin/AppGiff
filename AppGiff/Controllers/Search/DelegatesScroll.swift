import UIKit

extension SearchViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let translationY = scrollView.panGestureRecognizer.translation(in: scrollView.superview).y

        if translationY > 50 {
            UIView.animate(withDuration: 0.4) {
                self.searchView.viewForTabBar.transform = .identity
            }
        } else if translationY < -120 {
            UIView.animate(withDuration: 0.4) {
                self.searchView.viewForTabBar.transform = CGAffineTransform(translationX: 0, y: -200)
            }
        }
    }
}
