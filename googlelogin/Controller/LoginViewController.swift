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

class LoginViewController: UIViewController {
    
    var user: User!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        checkLoginGoogle()
        
        
        
        setupGoogleLogin()
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
    
    func checkLoginGoogle() {
        if let data = defaults.data(forKey: "User"), let u = NSKeyedUnarchiver.unarchiveObject(with: data) as? User {
            user = u
            print(u.avatar!)
            performSegue(withIdentifier: "Logged", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destViewController: HomeViewController = segue.destination as! HomeViewController
        destViewController.user = user
    }
}

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
    
}
