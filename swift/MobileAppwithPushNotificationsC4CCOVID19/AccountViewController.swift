
import UIKit
import BMSCore
import IBMCloudAppID

class AccountViewController: ViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var Logo: UIImageView!
    override func viewDidLoad() {
        loginButton.layer.cornerRadius = 10.0
        self.navigationItem.hidesBackButton = true
    }

    @IBAction func login(_ sender: Any) {
        let token = TokenStorageManager.sharedInstance.loadStoredToken()
        AppID.sharedInstance.loginWidget?.launch(accessTokenString: token, delegate: SigninDelegate(navigationController: self.navigationController!))
    }

}


