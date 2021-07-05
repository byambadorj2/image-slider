//
//  ViewController.swift
//  Image-slider
//
//  Created by World Plus on 5/28/21.
//  Copyright © 2021 World Plus. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage


class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    var userSlider : Array! = []
    var list : Array! = []
    
//  struct Sliders: Codable {
//        var sliders: String?
//        var items: Items?
//
//  }
//
//  struct Items: Codable {
//      var id, title: String?
//      var img: String?
//      var brand, desc: String?
//
//    enum CodingKeys: String, CodingKey {
//        case title
//        case img
//        case brand
//        case desc
//    }
//  }
    
  
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var ListCollectionView: UICollectionView!
    
    
    
    var currentIndex = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        pageControl.numberOfPages = userSlider.count
        
        collectionView.dataSource = self
        collectionView.delegate = self
        ListCollectionView.dataSource = self
        ListCollectionView.delegate = self
        
        
        
        let fileURL = Bundle.main.url(forResource: "input", withExtension: "json")
        AF.request(fileURL!).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let json = JSON(value)

                let jsonArray = json["sliders"]
                for i in jsonArray.arrayValue{
                    let Slider = i.stringValue
                    self.userSlider.append(Slider)
                }
                self.collectionView.reloadData()
                
                let listArray = json["items"]
                
                for l in listArray.arrayValue{
//                    let Item = l.stringValuez
                    self.list.append(l.arrayObject)
//                    print(l)
                }
                self.ListCollectionView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
      
       
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        if collectionView == self.collectionView {
             return userSlider.count
        }
        return list.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCell", for: indexPath) as! SliderCell
            let str : String = self.userSlider[indexPath.item] as! String
            let url = URL(string: str)
            cell.imageView.sd_setImage(with: url, placeholderImage: nil)
            return cell
        }
        else {
            let cellList = ListCollectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
            
//            cellList.productNameLabel.text =
            print(list)
            return cellList
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        currentIndex = Int(scrollView.contentOffset.x / collectionView.frame.size.width)
        
        pageControl.currentPage = currentIndex
    }
  
}

