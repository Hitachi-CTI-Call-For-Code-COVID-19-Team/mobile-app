//
//  AppDelegate.swift
//  MobileAppwithPushNotificationsC4CCOVID19
//

import UIKit
import UserNotifications
import BMSCore
import BMSPush



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    internal func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self

        

        // 元のコード
        let myBMSClient = BMSClient.sharedInstance
        myBMSClient.initialize(bluemixRegion: BMSClient.Region.jpTok)
        myBMSClient.requestTimeout = 10.0 // seconds

        

        if let contents = Bundle.main.path(forResource:"BMSCredentials", ofType: "plist"), let dictionary = NSDictionary(contentsOfFile: contents) {
            let push = BMSPushClient.sharedInstance
            push.initializeWithAppGUID(appGUID: dictionary["pushAppGuid"] as! String, clientSecret: dictionary["pushClientSecret"] as! String)
        }
        
        return true
    }

    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // アプリが起動している間に通知を受け取った場合の処理を行う。
        print("_________________FOREGROUND _________________")
    }


    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // システムへのプッシュ通知の登録が失敗した時の処理を行う。
    }
    
    // Initialize IBM Cloud Push Notifications client SDK and register device.
    func application (_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
        let push = BMSPushClient.sharedInstance

        // Replace USER_ID with a unique end user identifier. This enables specific push notification targeting.
        push.registerWithDeviceToken(deviceToken: deviceToken, WithUserId: "Shopper01") { (response, statusCode, error) -> Void in
            if error.isEmpty {
                 print("Response during device registration : \(String(describing: response))")
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
        
        if (message.contains("Risk status Chnaged: HIGH")) {
            turnDeveceLightRed()
        } else if (message.contains("Risk status Chnaged: OFF")) {
            turnDeviceLightOff()
        }
        
        completionHandler(UIBackgroundFetchResult.newData)
    }

    private func turnDeveceLightRed() {
        let event_name = "push_notification_received"
        callIFTTTWebSocket(event_name: event_name)
    }
    private func turnDeviceLightOff() {
        let event_name="turnoff"
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
        print("_________________WILL_RESIGN _________________")
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("_________________DID_ENTER_BACKGROUND _________________")
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print("_________________WILL_ENTER _________________")
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print("_________________DID_BECOME _________________")
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print("_________________WILL_TERMINATE _________________")
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // iOS 10 以降では通知を受け取るとこちらのデリゲートメソッドが呼ばれる。
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("_________________WILL _________________")
        
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
        print("_________________DID _________________")
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

}




