import UIKit

class StartView: UIView {

    @IBOutlet weak var versionLabel: UILabel!
    
    func setVersionLabel(value: String) {
        versionLabel.text = "Version " + String(value)
    }
}
