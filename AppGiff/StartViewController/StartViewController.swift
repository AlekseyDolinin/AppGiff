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
        let vc = storyboard?.instantiateViewController(withIdentifier: "MainViewController")
        navigationController?.pushViewController(vc!, animated: true)
    }

    // получение номера версии приложения
    func getVersionApp() {
        let nsObject: AnyObject? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject
        let version = nsObject as! String
        startView.setVersionLabel(value: version)
    }
    
    deinit {
        print("deinit StartViewController")
    }
}
