//
//  LoginViewController.swift
//  googlelogin
//
//  Created by Administrator on 11/28/17.
//  Copyright © 2017 Administrator. All rights reserved.
//

import UIKit
import Google
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import TwitterKit

class LoginViewController: UIViewController {
    
    var user = User()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        checkLoginGoogle()
        checkLoginFacebook()
        
        setupGoogleLogin()
        setupTwitter()
    }

    
    
    
    /////////
    //Segue//
    /////////
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destViewController: HomeViewController = segue.destination as! HomeViewController
        destViewController.user2 = self.user
    }
}




///////////
//Twitter//
///////////
extension LoginViewController {
    func setupTwitter() {
        let logInButton = TWTRLogInButton { (session, error) in
            if (session != nil) {
                print("signed in as \(String(describing: session?.userName))");
                self.loggedTwitter(id: (session?.userID)!)
            } else {
                print("error: \(String(describing: error?.localizedDescription))");
            }
        }
        logInButton.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        logInButton.center = self.view.center
        self.view.addSubview(logInButton)
    }
    
    
    func loggedTwitter(id: String) {
        if let userID = Twitter.sharedInstance().sessionStore.session()?.userID {
            let client = TWTRAPIClient(userID: userID)
            // make requests with client
            //            let client = TWTRAPIClient()
            
            let request = client.urlRequest(withMethod: "GET", url: "https://api.twitter.com/1.1/account/verify_credentials.json?include_email=true", parameters: ["include_email": "true", "skip_status": "true"], error: nil)
            
            
            
            client.sendTwitterRequest(request) { response, data, connectionError in
                if (connectionError == nil) {
                    
                    let json : AnyObject
                    
                    do{
                        json = try JSONSerialization.jsonObject(with: data!, options: []) as AnyObject
                        
                        print("Json response: ", json)
                        
                        if let name: String = json["name"] as? String {
                            self.user.name = name
                        }
                        
                        if let email: String = json["email"] as? String {
                            self.user.email = email
                        }
                        
                        if let profile_image_url_https: String = json["profile_image_url_https"] as? String {
                            self.user.avatar = profile_image_url_https
                        }
                        
                        
                        //UserDefaults
//                        self.user = User(name: (user?.name)!, avatar: (user?.profileImageLargeURL)!, email: "", age: "")
                        let encodeData = NSKeyedArchiver.archivedData(withRootObject: self.user)
                        self.defaults.set(encodeData, forKey: "User")
                        
                        self.performSegue(withIdentifier: "Logged", sender: self)
                        
                    } catch {
                        
                    }
                    
                }
                else {
                    print("Error: \(String(describing: connectionError))")
                }
            }
            
        }
    }
}

//////////
//Google//
//////////
extension LoginViewController: GIDSignInUIDelegate, GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
//            let userId = user.userID                  // For client-side use only!
//            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
//            let description = user.profile.description
//            let familyName = user.profile.familyName
            let email = user.profile.email
            // ...
            let dimension = round(180 * UIScreen.main.scale)
            let pic = user.profile.imageURL(withDimension: UInt(dimension))
            let url = pic?.absoluteString
            
            //UserDefaults
            self.user = User(name: fullName!, avatar: url! , email: email!, age: "")
            let encodeData = NSKeyedArchiver.archivedData(withRootObject: self.user)
            defaults.set(encodeData, forKey: "User")
            
            performSegue(withIdentifier: "Logged", sender: self)
        } else {
            print("\(error.localizedDescription)")
        }
    }
    func checkLoginGoogle() {
        if let data = defaults.data(forKey: "User"), let u = NSKeyedUnarchiver.unarchiveObject(with: data) as? User {
            user = u
            print(u.avatar!)
            performSegue(withIdentifier: "Logged", sender: self)
        }
    }
    func setupGoogleLogin() {
        var error: NSError?
        GGLContext.sharedInstance().configureWithError(&error)
        if error != nil {
            print(error!)
            return
        }
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }
}


////////////
//Facebook//
////////////
extension LoginViewController: FBSDKLoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        checkLoginFacebook()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    func checkLoginFacebook() {
        if FBSDKAccessToken.current() == nil {
            return
        }
        let parameters = ["fields": "email, name, birthday, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (connection, result, error) in
            if error != nil {
                print(error!)
                return
            }
            guard let data = result as? [String:Any] else { return }
            
            let u = User()
            print(data)
            if let dt = data["name"] as? String {
                u.name = dt
            }
            
            if let dt = data["birthday"] as? String {
                u.age = dt
            }
            
            if let picture = data["picture"] as? NSDictionary, let data = picture["data"] as? NSDictionary, let url = data["url"] as? String {
                u.avatar = url
            }
            self.user = u
            self.performSegue(withIdentifier: "Logged", sender: self)
        }
    }
}
