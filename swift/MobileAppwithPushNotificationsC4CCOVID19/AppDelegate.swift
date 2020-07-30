//
//  AppDelegate.swift
//  MobileAppwithPushNotificationsC4CCOVID19
//

import UIKit
import UserNotifications
import BMSCore
import BMSPush
import IBMCloudAppID



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, AuthorizationDelegate {

    

    var window: UIWindow?

    internal func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        AppID.sharedInstance.initialize(tenantId: "aeb33af2-52bb-44e5-97a4-cf67a3449c43", region:AppID.REGION_TOKYO)
        
        
        //let bmsclient = BMSClient.sharedInstance
        //bmsclient.initialize(bluemixRegion: BMSClient.Region.jpTok)

        UNUserNotificationCenter.current().delegate = self
        

        
        // 元のコード
        let myBMSClient = BMSClient.sharedInstance
        myBMSClient.initialize(bluemixRegion: BMSClient.Region.jpTok)
        myBMSClient.requestTimeout = 10.0 // seconds


        if let contents = Bundle.main.path(forResource:"BMSCredentials", ofType: "plist"), let dictionary = NSDictionary(contentsOfFile: contents) {
            
            let push = BMSPushClient.sharedInstance
            push.initializeWithAppGUID(appGUID: dictionary["pushAppGuid"] as! String, clientSecret: dictionary["pushClientSecret"] as! String)
        }

    
        if let contents = Bundle.main.path(forResource:"BMSCredentials", ofType: "plist"), let _ = NSDictionary(contentsOfFile: contents) {
             // Common
             let region = AppID.REGION_TOKYO
             let bmsclient = BMSClient.sharedInstance
             bmsclient.requestTimeout = 10.0 // seconds
             
             // AppID
             let backendGUID = "aeb33af2-52bb-44e5-97a4-cf67a3449c43"
             //bmsclient.initialize(bluemixRegion: region)
             let appid = AppID.sharedInstance
             appid.initialize(tenantId: backendGUID, region: region)
             let appIdAuthorizationManager = AppIDAuthorizationManager(appid:appid)
             bmsclient.authorizationManager = appIdAuthorizationManager
             TokenStorageManager.sharedInstance.initialize(tenantId: backendGUID)

         }

        
 
        
        //AppID.sharedInstance.loginWidget?.launch(delegate: self)
        
        
        return true
    }

    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print("_________________FOREGROUND _________________")
    }


    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    }
    
    // Initialize IBM Cloud Push Notifications client SDK and register device.
    func application (_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
        let push = BMSPushClient.sharedInstance

        // Replace USER_ID with a unique end user identifier. This enables specific push notification targeting.
        push.registerWithDeviceToken(deviceToken: deviceToken, WithUserId: "st0001") { (response, statusCode, error) -> Void in
            if error.isEmpty {
                
                print("Response during device registration : \(String(describing: response))")
                struct Response: Decodable{
                    let createdTime: String
                    let platform: String
                    let token: String
                    let userId: String
                    let createdMode: String
                    let href: String
                    let deviceId: String
                    let lastUpdatedTime: String
                }
                do {
                    let res = try JSONDecoder().decode(Response.self, from: response!.data(using: .utf8)!)
                    print("UserId: " + res.userId)
                    print("DeviceId: " + res.deviceId)
                } catch {
                    print("parse error!")
                }
                print("status code during device registration : \(String(describing: statusCode))")
             } else {
                 print("Error during device registration \(error)")
                 print("Error during device registration \n  - status code: \(String(describing: statusCode)) \n  - Error: \(error) \n")
             }
        }
    }
    
    // Alerts the user of a received push notification when the app is running in the foreground.
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("_________________BACKGROUND _________________")
        // UserInfo dictionary will contain data sent from the server.
        var userPayload = String()
        let payload = ((((userInfo as NSDictionary).value(forKey:"aps") as! NSDictionary).value(forKey:"alert") as! NSDictionary).value(forKey:"title") as! NSString)
        let additionalPayload = (userInfo as NSDictionary).value(forKey:"payload")
        userPayload = additionalPayload.debugDescription

        //let alert = UIAlertController(title: "Push Notification Received", message: payload as String, preferredStyle: UIAlertController.Style.alert)
        //alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        //application.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)

        print("Recieved IBM Cloud Push Notifications message: " + (payload as String) + ", payload: " + (userPayload as String))
        var message = (payload as String).trimmingCharacters(in: .whitespacesAndNewlines)
        message = message.replacingOccurrences(of: "\n", with:" ", options: NSString.CompareOptions.literal, range: nil)
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        Messages.append(formatter.string(from:date) + "\n" + message)
        UserDefaults.standard.set(Messages, forKey: "Messages")
        
        if (message.contains("Current Risk: high")) {
            turnDeveceLightRed()
            Status = "HIGH"
        } else if (message.contains("Current Risk: acceptable")) {
            turnDeveceLightYellow()
            Status = "ACCEPTABLE"
        } else if (message.contains("Current Risk: low")) {
            turnDeveceLightGreen()
            Status = "LOW"
        } else if (message.contains("indicator: off")) {
            turnDeviceLightOff()
        }
        UserDefaults.standard.set(Status, forKey: "Status")
        
        completionHandler(UIBackgroundFetchResult.newData)
    }

    private func turnDeveceLightRed() {
        let event_name = "push_notification_received_turn_red"
        callIFTTTWebSocket(event_name: event_name)
    }
    private func turnDeveceLightYellow() {
        let event_name = "push_notification_received_turn_yellow"
        callIFTTTWebSocket(event_name: event_name)
    }
    private func turnDeveceLightGreen() {
        let event_name = "push_notification_received_turn_green"
        callIFTTTWebSocket(event_name: event_name)
    }
    private func turnDeviceLightOff() {
        let event_name="push_notification_received_turnoff"
        callIFTTTWebSocket(event_name: event_name)
    }
    private func callIFTTTWebSocket(event_name: String) {
        let url = URL(string: "https://maker.ifttt.com/trigger/" + event_name + "/with/key/b-WjlpNUimyG7zhYxCjcHKENfZlc92GcgCuBiwsMmXf")!
        post(url: url)
    }
    private func post(url: URL) {
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in guard let data = data else { return }
            do {
                let object = try JSONSerialization.jsonObject(with:data, options: [])
                print(object)
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        //print("_________________WILL_RESIGN _________________")
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        //print("_________________DID_ENTER_BACKGROUND _________________")
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        //print("_________________WILL_ENTER _________________")
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        //print("_________________DID_BECOME _________________")
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        //print("_________________WILL_TERMINATE _________________")
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // iOS 10 以降では通知を受け取るとこちらのデリゲートメソッドが呼ばれる。
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //print("_________________WILL _________________")
        
        let userInfo = notification.request.content.userInfo;
        // UserInfo dictionary will contain data sent from the server.
        var userPayload = String()
        let payload = ((((userInfo as NSDictionary).value(forKey:"aps") as! NSDictionary).value(forKey:"alert") as! NSDictionary).value(forKey:"body") as! NSString)
        let additionalPayload = (userInfo as NSDictionary).value(forKey:"payload")
        userPayload = additionalPayload.debugDescription

        //let alert = UIAlertController(title: "Push Notification Received", message: payload as String, preferredStyle: UIAlertController.Style.alert)
        //alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        //application.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)

        print("Recieved IBM Cloud Push Notifications message: " + (payload as String) + ", payload: " + (userPayload as String))
        var message = (payload as String).trimmingCharacters(in: .whitespacesAndNewlines)
        message = message.replacingOccurrences(of: "\n", with:" ", options: NSString.CompareOptions.literal, range: nil)
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        Messages.append(formatter.string(from:date) + "\n" + message)
        UserDefaults.standard.set(Messages, forKey: "Messages")
        
        
        
        completionHandler([])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        //print("_________________DID _________________")
        let userInfo = response.notification.request.content.userInfo;
        // UserInfo dictionary will contain data sent from the server.
        var userPayload = String()
        let payload = ((((userInfo as NSDictionary).value(forKey:"aps") as! NSDictionary).value(forKey:"alert") as! NSDictionary).value(forKey:"body") as! NSString)
        let additionalPayload = (userInfo as NSDictionary).value(forKey:"payload")
        userPayload = additionalPayload.debugDescription

        //let alert = UIAlertController(title: "Push Notification Received", message: payload as String, preferredStyle: UIAlertController.Style.alert)
        //alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        //application.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)

        print("Recieved IBM Cloud Push Notifications message: " + (payload as String) + ", payload: " + (userPayload as String))
        var message = (payload as String).trimmingCharacters(in: .whitespacesAndNewlines)
        message = message.replacingOccurrences(of: "\n", with:" ", options: NSString.CompareOptions.literal, range: nil)
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        Messages.append(formatter.string(from:date) + "\n" + message)
        UserDefaults.standard.set(Messages, forKey: "Messages")
        completionHandler()
    }
    func onAuthorizationCanceled() {
        print("login canceled")
    }
    
    func onAuthorizationFailure(error: AuthorizationError) {
        print("login failure")
    }
    
    func onAuthorizationSuccess(accessToken: AccessToken?, identityToken: IdentityToken?, refreshToken: RefreshToken?, response: Response?) {
        print("login success")
    }
    // for AppID
    func application(_ application: UIApplication, open url: URL, options :[UIApplication.OpenURLOptionsKey : Any]) -> Bool {
            return AppID.sharedInstance.application(application, open: url, options: options)
    }
}




