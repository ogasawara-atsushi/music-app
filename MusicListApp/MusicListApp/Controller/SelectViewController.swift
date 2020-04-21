//
//  SelectViewController.swift
//  MusicListApp
//
//  Created by saya on 2020/03/13.
//  Copyright © 2020 saya. All rights reserved.
//

import UIKit
import VerticalCardSwiper
import SDWebImage
import PKHUD
import Firebase
import ChameleonFramework


class SelectViewController: UIViewController, VerticalCardSwiperDelegate, VerticalCardSwiperDatasource {
    
    
    //受け取り用
    var artistNames = [String]()
    var musicNames = [String]()
    var previewURLs = [String]()
    var imageStrs = [String]()
    
    var indexNumber = Int()
    var userID = String()
    var userName = String()
    
    //右にスワイプしたときに好きなものを入れる配列
    var likeArtistNames = [String]()
    var likeMusivNames = [String]()
    var likePreviewURLs = [String]()
    var likeImageStrs = [String]()
    var likeArtistViewUrlStrs = [String]()
    
    @IBOutlet weak var cardSwiper: VerticalCardSwiper!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cardSwiper.delegate = self
        cardSwiper.datasource = self
        cardSwiper.register(nib: UINib(nibName: "CardViewCell", bundle: nil), forCellWithReuseIdentifier: "CardViewCell")
        
        cardSwiper.reloadData()
        // Do any additional setup after loading the view.
    }
    
    func numberOfCards(verticalCardSwiperView: VerticalCardSwiperView) -> Int {
        return artistNames.count
    }
    
    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
        if let cardCell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: "CardViewCell", for: index) as? CardViewCell {
            verticalCardSwiperView.backgroundColor = UIColor.randomFlat()
            view.backgroundColor = verticalCardSwiperView.backgroundColor
            
            //セル（カード）に配列を表示させる
            let artistName = artistNames[index]
            let musicName = musicNames[index]
            cardCell.setRandomBackgroundColor()
            cardCell.artistNameLabel.text = artistName
            cardCell.artistNameLabel.textColor = UIColor.white
            cardCell.musicNameLabel.text = musicName
            cardCell.musicNameLabel.textColor = UIColor.white
            
            cardCell.artWorkImageView.sd_setImage(with: URL(string: imageStringArray[index]), completed: nil)
            
            return cardCell
            
        }
        return CardCell()
    }
    
    
    func didSwipeCardAway(card: CardCell, index: Int, swipeDirection: SwipeDirection) {
        indexNumber = index //何番めがスワイプされたかを検知。検知したものをindexNumberに入れる
        //q:なぜここはvarとかletをつけていないんですか
        
        //右にスワイプしたときに呼ばれる箇所
        if swipeDirection == .Right {
            //右にスワイプした時に好きなものとして、新しい配列に入れてあげる
            likeArtistNames.append(artistNames[indexNumber])
            likeMusivNames.append(musicNames[indexNumber])
            likePreviewURLs.append(previewURLs[indexNumber])
            likePreviewURLs.append(imageStrs[indexNumber])
            
            if likeArtistNames.count != 0 && likeMusivNames.count != 0 && likePreviewURLs.count != 0 && likePreviewURLs.count != 0 {
                
                let musicDataModel = MusicDataModel(artistName: artistNames[indexNumber], musicName: musicNames[indexNumber], previewURL: previewURLs[indexNumber], imageString: imageStrs[indexNumber], userID: userID, userName: userName)
                
                musicDataModel.save()
            }
        }
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
