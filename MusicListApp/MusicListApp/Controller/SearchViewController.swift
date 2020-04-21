//
//  SearchViewController.swift
//  MusicListApp
//
//  Created by saya on 2020/03/12.
//  Copyright © 2020 saya. All rights reserved.
//

import UIKit
import PKHUD
import Alamofire
import SwiftyJSON
import DTGradientButton
import Firebase
import FirebaseAuth
import ChameleonFramework

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var favButton: UIButton!
    @IBOutlet private weak var listButton: UIButton!
    
    private var artistNames = [String]()
    private var musivNames = [String]()
    private var previewURLs = [String]()
    private var imageStrs = [String]()
    private var userID = String()
    private var userName = String()
    private var autoID = String()

    // MARK: - LifeCyle

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if searchTextField.text != nil && segue.identifier == "selectVC" {
            let selectVC = segue.destination as! SelectViewController
            selectVC.artistNames = self.artistNames
            selectVC.musivNameArray = self.musicNameArray
            selectVC.previewURLs = self.previewURLs
            selectVC.imageStrs = self.imageStrs
            selectVC.userID = self.userID
            selectVC.userName = self.userName
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.object(forKey: "autoID") != nil {
            autoID = UserDefaults.standard.object(forKey: "autoID") as! String
            print(autoID)
        } else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(identifier: "LoginViewController")
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: true, completion: nil)
        }
        
        if UserDefaults.standard.object(forKey: "userID") != nil && UserDefaults.standard.object(forKey: "userName") != nil {
            userID = UserDefaults.standard.object(forKey: "userID") as! String
            userName = UserDefaults.standard.object(forKey: "userName") as! String
        }
        
        searchTextField.delegate = self
        searchTextField.becomeFirstResponder()
        
        favButton.setGradientBackgroundColors([UIColor(hex:"E21F70"), UIColor(hex:"FF4D2C")], direction: .toBottom, for: .normal)
        listButton.setGradientBackgroundColors([UIColor(hex:"a18cd1"), UIColor(hex:"fbc2eb")], direction: .toBottom, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //ナビゲーションバーのBackButtonを消す
        
        //バーの色
        self.navigationController?.navigationBar.standardAppearance.backgroundColor = UIColor.flatRed()
        self.navigationItem.setHidesBackButton(true, animated: true)
    }

    // MARK: - Private Method

    func moveToCard() {
        performSegue(withIdentifier: "selectVC", sender: nil)
    }

    func startParse(keyword:String) {
        //ぐるぐるを表示
        HUD.show(.progress)

        imageStrings.removeAll()
        previewURLs = [String]()
        artistNames = [String]()
        musicNameArray = [String]()

        let urlString = "https://itunes.apple.com/search?term=\(keyword)&country=jp"
        let encodeUrlString:String = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        AF.request(encodeUrlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON{
            (response) in

            print(response)

            switch response.result {
            case .success:

                let json: JSON = JSON(response.data as Any)
                print(json)

                var resultCount: Int = json["resultCount"].int!

                for i in 0 ..< resultCount {
                    var artWorkUrl = json["results"][i]["artworkUrl60"].string
                    let previewUrl = json["results"][i]["previewUrl"].string
                    let artistName = json["results"][i]["artistName"].string
                    let trackCensoredName = json["results"][i]["trackCensoredName"].string

                    if let range = artWorkUrl!.range(of: "60×60bb"){
                        artWorkUrl?.replaceSubrange(range, with: "320×320bb")
                    }

                    self.imageStringArray.append(artWorkUrl!)
                    self.previewURLArray.append(previewUrl!)
                    self.artistNameArray.append(artistName!)
                    self.musicNameArray.append(trackCensoredName!)

                    if self.musicNameArray.count == resultCount {
                        //カード画面へ遷移
                        self.moveToCard()
                    }
                }

                //繰り返し処理を抜けたら、ぐるぐるを閉じる
                HUD.hide()

            case .failure(let error):
                print(error)
            }
        }
    }

    // MARK: - Action

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchTextField.resignFirstResponder()
    }
    
    @IBAction func moveToSelectCardView(_ sender: Any) {
        //パースを行う
        startParse(keyword: searchTextField.text!)
    }
}

// MARK: - UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        //Searchを行う

        textField.resignFirstResponder()
        return true
    }
}
