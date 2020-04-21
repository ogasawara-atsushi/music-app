//
//  SaveProfile.swift
//  MusicListApp
//
//  Created by saya on 2020/03/11.
//  Copyright © 2020 saya. All rights reserved.
//

import Foundation
import Firebase
import PKHUD

class Profile {
    //サーバーに値を飛ばす
    var userID: String! = ""
    var userName: String! = ""
    var ref: DatabaseReference!
    
    init(userID: String, userName: String) {
        self.userID = userID
        self.userName = userName
        
        //ログインのときに拾えるuidを先頭につけて送信する。受信するときもuidからひ引っ張ってくる
        ref = Database.database().reference().child("plofile").childByAutoId()
    }
    
    init(snapShot: DataSnapshot) {
        ref = snapShot.ref
        if let value = snapShot.value as? [String:Any]{
            userID = value["userID"] as? String
            userName = value["userName"] as? String
        }
    }
    
    func toContents()->[String:Any]{
        return ["userID":userID!,"userName":userName as Any]
    }
    
    func save(){
        ref.setValue(toContents())
        UserDefaults.standard.set(ref.key, forKey: "autoID")
    }
    
}
