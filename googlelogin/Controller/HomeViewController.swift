//
//  HomeViewController.swift
//  googlelogin
//
//  Created by Administrator on 11/28/17.
//  Copyright © 2017 Administrator. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelAge: UILabel!
    
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    func handleLogout() {
        defaults.removeObject(forKey: "User")
        performSegue(withIdentifier: "Logout", sender: nil)
    }
    
    var user: User? {
        didSet {
            if let dt = user?.name {
                DispatchQueue.main.async {
                    self.labelName.text = dt
                }
                
            }
            if let dt = user?.age {
                DispatchQueue.main.async {
                    self.labelAge.text = dt
                }
            }
            if let dt = user?.email {
                DispatchQueue.main.async {
                    self.labelEmail.text = dt
                }
            }
            if let dt = user?.email {
                DispatchQueue.main.async {
                    self.labelEmail.text = dt
                }
            }
            if let dt = user?.avatar, let u = URL(string: dt) {
                
                let session = URLSession(configuration: .default)
                // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
                let downloadPicTask = session.dataTask(with: u) { (data, response, error) in
                    // The download has finished.
                    if let e = error {
                        print("Error downloading cat picture: \(e)")
                    } else {
                        // No errors found.
                        // It would be weird if we didn't have a response, so check for that too.
                        if let res = response as? HTTPURLResponse {
                            print("Downloaded cat picture with response code \(res.statusCode)")
                            if let imageData = data {
                                // Finally convert that Data into an image and do what you wish with it.
                                let image = UIImage(data: imageData)
                                // Do something with your image.
                                DispatchQueue.main.async(execute: {
                                    self.imageAvatar.image = image
                                })
                            } else {
                                print("Couldn't get image: Image is nil")
                            }
                        } else {
                            print("Couldn't get response code for some reason")
                        }
                    }
                }
                downloadPicTask.resume()
            }
        }
    }
}
