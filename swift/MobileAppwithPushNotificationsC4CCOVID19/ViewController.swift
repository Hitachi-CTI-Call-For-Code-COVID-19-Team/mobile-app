//
//  ViewController.swift
//  MobileAppwithPushNotificationsC4CCOVID19
//

import UIKit
import IBMCloudAppID
import MapKit
import BMSCore

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let refreshToken = TokenStorageManager.sharedInstance.loadStoredRefreshToken()
        if (refreshToken != nil) {
            AppID.sharedInstance.signinWithRefreshToken(refreshTokenString: refreshToken!, tokenResponseDelegate: SigninDelegate(navigationController: self.navigationController!))
        } else {
            SigninDelegate.navigateToLandingView(navigationController: self.navigationController)
        }
        

        // CircularProgressChart
        let cp = CircularProgressView(frame: CGRect(x: 0.0, y: 0.0, width: 140.0, height: 140.0))
        //cp.trackColor = UIColor(red: CGFloat(28)/255, green: CGFloat(28)/255, blue: CGFloat(30)/255.0, alpha: 1)
        cp.trackColor = UIColor.systemGray6
        cp.progressColor = UIColor.systemBlue
        cp.tag = 101
        self.view.addSubview(cp)
        cp.center = self.view.center
        
        self.perform(#selector(animateProgress), with: nil, afterDelay: 2.0)
        
        /*
        let link = CADisplayLink(target: self, selector: #selector(updateValue))
        link.add(to: .current, forMode: .RunLoop.Mode.common)
         */
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(userDefaultsDidChange), name: UserDefaults.didChangeNotification, object: nil)

    }

    @objc func animateProgress() {
        let cP = self.view.viewWithTag(101) as! CircularProgressView
        cP.setProgressWithAnimation(duration: 1.0, value: 1.0) // TODO
        //cP.setTextWithAnimation(duration: 1.0, value: 15000)
        cP.setText(text: Status)
        
    }
    
    /*
    var startTime : CFTimeInterval!
    var duration : TimeInterval!
    var fromValue : Int!
    var toValue : Int!
    @objc func updateValue(link: CADisplayLink) {
        let dt = (link.timestamp - startTime) / duration
        if dt >= 1.0 {
            self.label.text = String(toValue)
            link.invalidate()
            return
        }
        let current = Int(Double(toValue - fromValue) * dt) + fromValue
        self.label.text = String(current)
    }
    */
    
    @objc func didBecomeActive(_ notification: Notification) {
        
    }
    
    @objc func userDefaultsDidChange(_ notification: Notification) {
        animateProgress()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
