//
//  LoginViewController.swift
//  MusicListApp
//
//  Created by saya on 2020/03/11.
//  Copyright © 2020 saya. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import DTGradientButton

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textfield.delegate = self
        
        //ボタンの背景色
        loginButton.setGradientBackgroundColors([UIColor(hex:"E21F70"), UIColor(hex:"FF4D2C")], direction: .toBottom, for: .normal)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textfield.resignFirstResponder()
        return true
    }

    @IBAction func login(_ sender: Any) {
        //もしtextfieldの値が空でない場合、
        if textfield.text?.isEmpty != true {
            //textfieldの値（ユーザー名）を自分のアプリ名に保存しておく
            UserDefaults.standard.set(textfield.text, forKey: "userName")
        } else{
            //空ならば、振動させる
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            print("振動")
        }
        //FirebaseAuthのなかにIDとtextfield.textを入れる
        Auth.auth().signInAnonymously { (result, error) in
            if error == nil {
                guard let user = result?.user else{ return }
                let userID = user.uid
                UserDefaults.standard.set(userID, forKey: "userID")
            } else{
                print(error?.localizedDescription as Any)
                //アラート
            }
        }
        
    }
    
    
}
