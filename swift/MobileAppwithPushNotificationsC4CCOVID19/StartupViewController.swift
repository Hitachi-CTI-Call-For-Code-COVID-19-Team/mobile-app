//
//  StartupViewController.swift

import UIKit
import IBMCloudAppID
import BMSCore


class StartupViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let refreshToken = TokenStorageManager.sharedInstance.loadStoredRefreshToken()
        if (refreshToken != nil) {
            AppID.sharedInstance.signinWithRefreshToken(refreshTokenString: refreshToken!, tokenResponseDelegate: SigninDelegate(navigationController: self.navigationController!))
        } else {
            SigninDelegate.navigateToLandingView(navigationController: self.navigationController)
        }
    }
}
