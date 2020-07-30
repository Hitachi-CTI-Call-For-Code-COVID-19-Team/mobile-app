/* *     Copyright 2016, 2017 IBM Corp.
 *     Licensed under the Apache License, Version 2.0 (the "License");
 *     you may not use this file except in compliance with the License.
 *     You may obtain a copy of the License at
 *     http://www.apache.org/licenses/LICENSE-2.0
 *     Unless required by applicable law or agreed to in writing, software
 *     distributed under the License is distributed on an "AS IS" BASIS,
 *     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *     See the License for the specific language governing permissions and
 *     limitations under the License.
 */



import UIKit
import IBMCloudAppID
import BMSCore

let newGuest = "We created a new anonymous profile for the guest user. We will store the user’s food preferences there. Note that this anonymous user profile is only available from this device."
let progressive = "A guest user logged-in for the first time. App ID assigned this user’s identity to their anonymous profile, so their previous selections are saved. The user now has an identified profile, and the anonymous token previously used to access his profile is now invalid."
let returningGuest = "A guest user returned. The app uses his existing anonymous profile, so his previous selections are saved. Note that this anonymous user profile is only available from this device."
let returningLogin = "An identified user returned to the app with the same identity. The app accesses his identified profile and the previous selections that he made."
let otherLogin = "The user signed back into the device with a new identity (i.e. was with Facebook, now with Google).If he used this identity previously - the app uses the profile for that existing identity. Else, App ID creates a new profile."
let differentLogin = "A user started to use the app anonymously, made some selections, and then logged in. Since he had logged in in the past, the app switches over to his existing identified profile in place of his anonymous profile. The user sees selections he made as an identified user."
let newLogin = "We created a new anonymous profile for the guest user. We will store the user’s food preferences there. Note that this anonymous user profile is only available from this device. "

class AfterLoginViewController: UIViewController {
/*

    @IBOutlet weak var selection1: UIView!
    @IBOutlet weak var selection2: UIView!
    @IBOutlet weak var selection3: UIView!

    @IBOutlet weak var toptext: UILabel!
    @IBOutlet weak var pizzaIcon: UIImageView!

    @IBOutlet weak var selectionIcon1: UIImageView!
    @IBOutlet weak var selectionIcon2: UIImageView!
    @IBOutlet weak var selectionIcon3: UIImageView!
    @IBOutlet weak var profilePic: UIImageView!

    @IBOutlet weak var hintMessageView: UILabel!
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var nextLabel: UILabel!
    @IBOutlet weak var successMsg: UILabel!
    // function for displaying login
  //  @IBOutlet weak var warningText: UILabel!

    @IBOutlet weak var signinButton: UIButton!
*/
    var accessToken:AccessToken?
    var idToken:IdentityToken?
    var refreshToken: RefreshToken?
    var foodSelection : Array<String> = []
    var firstLogin: Bool = false
    var hintMessage : String?

    override func viewDidLoad() {

 /*
        self.profilePic.layer.cornerRadius = self.profilePic.frame.size.height / 2;
        self.profilePic.layer.masksToBounds = true;

        self.selectionIcon1.isHidden = !self.foodSelection.contains("pizza")
        self.selectionIcon2.isHidden = !self.foodSelection.contains("hamburger")
        self.selectionIcon3.isHidden = !self.foodSelection.contains("salad")

        selection1.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (self.selection1Clicked(sender:))))
        selection2.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (self.selection2Clicked(sender:))))
        selection3.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (self.selection3Clicked(sender:))))
        topBar.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (self.topBarClicked(sender:))))

        self.profilePic.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (self.profilePicClicked(sender:))))
        self.profilePic.isUserInteractionEnabled = true


        showLoginInfo()
        loadFoodSelectionFromServer()
 */
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    func showLoginInfo() {
/*
        // Getting and presenting the user picture

        if !(accessToken?.isAnonymous)! {
            if let picUrl = idToken?.picture, let url = URL(string: picUrl), let data = try? Data(contentsOf: url) {
                self.profilePic.image = UIImage(data: data)
            }
            toptext.text = "You got 150 points, go get a pizza";
            pizzaIcon.isHidden = false;
            signinButton.isHidden = true
        } else {
            toptext.text = "Sign in to get a gift >";
            pizzaIcon.isHidden = true;
            signinButton.isHidden = false
        }

        let displayName = idToken?.name ?? (idToken?.email?.components(separatedBy: "@"))?[0] ?? "Guest"
        self.successMsg.text = "Welcome " + displayName + ""
 */

    }
/*
    @objc func selection1Clicked(sender: UITapGestureRecognizer) {
        updateFoodSelection(foodItem: "pizza")
    }

    @objc func selection2Clicked(sender: UITapGestureRecognizer) {
        updateFoodSelection(foodItem: "hamburger")
    }

    @objc func selection3Clicked(sender: UITapGestureRecognizer) {
        updateFoodSelection(foodItem: "salad")
    }

    @objc func profilePicClicked(sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if (accessToken?.authenticationMethods?[0] == "cloud_directory") {
            alert.addAction(UIAlertAction(title: "Account Details", style: .default) { _ in
                AppID.sharedInstance.loginWidget?.launchChangeDetails(SigninDelegate(navigationController: self.navigationController!))
            })

            alert.addAction(UIAlertAction(title: "Change Password", style: .default) { _ in
                AppID.sharedInstance.loginWidget?.launchChangePassword(SigninDelegate(navigationController: self.navigationController!))
            })
        }

        if accessToken!.isAnonymous {
            alert.addAction(UIAlertAction(title: "Sign in", style: .default) { _ in
                self.signIn()
            })
        } else {
            alert.addAction(UIAlertAction(title: "Sign Out", style: .default) { _ in
                self.signOut(sender)
            })
        }

        alert.addAction(UIAlertAction(title: "Cancel",
                                         style: .cancel) { (action) in
        })

        present(alert, animated: true)
    }
*/

    class LoginDelegate : AuthorizationDelegate {

        let controller : AfterLoginViewController

        init(controller : AfterLoginViewController) {
            self.controller = controller
        }

        public func onAuthorizationSuccess(accessToken: AccessToken?, identityToken: IdentityToken?,
                                           refreshToken: RefreshToken?,
                                           response:Response?) {
            guard accessToken != nil || identityToken != nil else {
                return
            }
            controller.accessToken = accessToken;
            controller.idToken = identityToken;

            
            controller.selectHintMessage(prevAnon: (TokenStorageManager.sharedInstance.loadStoredToken() != nil), prevId: TokenStorageManager.sharedInstance.loadUserId(), currentAnon: accessToken!.isAnonymous, currentId: accessToken!.subject!)

            if accessToken!.isAnonymous {
                TokenStorageManager.sharedInstance.storeToken(token: accessToken!.raw)
            } else {
                TokenStorageManager.sharedInstance.clearStoredTokens()
            }
            if (refreshToken != nil) {
                TokenStorageManager.sharedInstance.storeRefreshToken(token: refreshToken!.raw)
            }
            TokenStorageManager.sharedInstance.storeUserId(userId: accessToken!.subject)


            DispatchQueue.main.async {
                self.controller.showLoginInfo()

            }

             //controller.loadFoodSelectionFromServer()
        }

        public func onAuthorizationCanceled() {
            print("cancel")
        }

        public func onAuthorizationFailure(error: AuthorizationError) {
            print(error)
        }
    }

    func selectHintMessage(prevAnon: Bool, prevId: String?, currentAnon: Bool, currentId: String) {
        if prevId != nil {
            if prevAnon {
                if currentAnon {
                    if currentId == prevId {
                        hintMessage = returningGuest
                    } else {
                        hintMessage = newGuest
                    }
                } else {
                    if currentId == prevId {
                        hintMessage = progressive
                    } else {
                        hintMessage = differentLogin
                    }
                }
            } else {
                if currentAnon {
                    hintMessage = newGuest
                } else {
                    if currentId == prevId {
                        hintMessage = returningLogin
                    } else {
                        hintMessage = otherLogin
                    }
                }
            }
        } else {
            if currentAnon {
                hintMessage = newGuest
            } else {
                hintMessage = newLogin
            }
        }
    }
/*
    @objc func topBarClicked(sender: UITapGestureRecognizer) {
        signIn()
    }

    func signIn() {
        if (accessToken?.isAnonymous)! {
            AppID.sharedInstance.loginWidget?.launch(accessTokenString: TokenStorageManager.sharedInstance.loadStoredToken(), delegate: LoginDelegate(controller: self))
        }
    }
 */

/*
    @IBAction func showToken(_ sender: Any) {
        let tokenView  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TokenView") as? TokenView
        tokenView?.accessToken = self.accessToken
        tokenView?.idToken = self.idToken
        tokenView?.refreshToken = self.refreshToken
        self.present(tokenView!, animated: true, completion: nil)
    }

    @IBAction func showUserInfo(_ sender: Any) {
        let userInfoView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserInfoView") as? UserInfoViewController
        self.present(userInfoView!, animated: true, completion: nil)
    }
 */

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    func updateUI() {
        DispatchQueue.main.async {
            /*
            self.selectionIcon1.isHidden = !self.foodSelection.contains("pizza")
            self.selectionIcon2.isHidden = !self.foodSelection.contains("hamburger")
            self.selectionIcon3.isHidden = !self.foodSelection.contains("salad")
            self.hintMessageView.text = self.hintMessage
 */
        }

    }
/*
    func updateFoodSelection(foodItem : String) {
        if let index = foodSelection.index(of: foodItem) {
            foodSelection.remove(at: index)
        } else {
            foodSelection.append(foodItem)
        }

        updateUI()


        AppID.sharedInstance.userProfileManager?.setAttribute(key: "foodSelection", value: getFoodSelectionJson(), completionHandler: { (error, attributes) in
            guard error == nil else {
                print("Failed to store selection in profile")
                return
            }
            print("stored selection in profile")

        })
    }

    func loadFoodSelectionFromServer() {
        let accessTokenString = (accessToken?.raw)!
        AppID.sharedInstance.userProfileManager?.getAttributes(accessTokenString: accessTokenString, completionHandler: { (error, attributes) in
            guard error == nil else {
                print("Failed to load selection from profile", error!)
                return
            }

            // we give all non guest users 150 points
            if (attributes?["points"] == nil) {

                AppID.sharedInstance.userProfileManager?.setAttribute(key: "points", value: "150", accessTokenString: accessTokenString, completionHandler: { (error, attributes) in
                    guard error == nil else {
                        print("Failed to save points", error!)
                        return
                    }

                })

            } else {
                // this user already got points
                if (self.hintMessage == newLogin) {
                    self.hintMessage = returningLogin;
                }
            }

            self.saveFoodSelection(jsonArrayString: attributes?["foodSelection"] as? String)
            self.updateUI()

        })
    }

    func getFoodSelectionJson() -> String {
        do {
        let jsonData = try JSONSerialization.data(withJSONObject: foodSelection)
        return String(data: jsonData, encoding: .utf8)!
        } catch {
            return "[]"
        }
    }

    func saveFoodSelection(jsonArrayString : String?) {
        if jsonArrayString != nil {
            do {
                let array = try JSONSerialization.jsonObject(with: jsonArrayString!.data(using: .utf8)!)
                foodSelection = array as! Array<String>
            } catch {}
        } else {
            foodSelection = []
        }

    }

    @IBAction func signOut(_ sender: Any) {
        AppID.sharedInstance.logout()
        self.navigationController!.popToRootViewController(animated: false)
    }


    @IBAction func signInButtonClicked(_ sender: Any) {
        signIn()
    }
 */

}

