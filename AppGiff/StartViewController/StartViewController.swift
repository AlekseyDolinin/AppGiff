import UIKit

class StartViewController: UIViewController {
    
    private var startView: StartView! {
        guard isViewLoaded else {return nil}
        return (view as! StartView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getVersionApp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) { [weak self] in
            let vc = self?.storyboard?.instantiateViewController(withIdentifier: "MainViewController")
            vc?.modalPresentationStyle = .fullScreen
            self?.present(vc!, animated: false, completion: nil)
        }
    }

    // получение номера версии приложения
    func getVersionApp() {
        let nsObject: AnyObject? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject
        let version = nsObject as! String
        startView.versionLabel.text = "Version " + String(version)
    }
    
    deinit {
        print("deinit StartViewController")
    }
}
