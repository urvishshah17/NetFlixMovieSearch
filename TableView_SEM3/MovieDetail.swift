//
//  LIstVC.swift
//  TableView_SEM3
//
//  Created by MacStudent on 2017-05-18.
//  Copyright © 2017 MacStudent. All rights reserved.
//

import UIKit
import EasyPeasy
import AVKit
import AVFoundation
import EasyPeasy


class MovieDetail: UIViewController{

    var nameArray = [String]()
    var imgArray = [String]()
    public var titleName: String!
    
    let namelabel : UILabel = {
        let label = UILabel()
        label.text = "Movies Detail"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    let urlString = "http://netflixroulette.net/api/api.php?title="
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(titleName)
        self.downloadJsonDataWithURL()
        self.setupViews()
    }
    
    
    func downloadJsonDataWithURL()
    {
        
        guard let finalString = "\(urlString)\(titleName!)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        let url = URL(string: finalString)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? Dictionary<String,Any>
            {
               /* if let itemsArray = jsonObj as? Dictionary<String,Any>
                    //.value(forKey: "actors") as? NSArray
                {
                    for item in itemsArray
                    {
                        if let itemDict = item as? Dictionary<String,Any>
                        {
                            if let name = itemDict["summary"]
                            {
                                self.nameArray.append(name as! String)
                            }
                            
                            if let image = itemDict["poster"]
                            {
                                self.imgArray.append(image as! String)
                            }
                            
                            
                            OperationQueue.main.addOperation {
                                self.tableView.reloadData()
                            }
                        }
                    }
                } */
                let summary = jsonObj?["summary"] as? String
                DispatchQueue.main.async {
                    self.namelabel.text = summary
                }
                
            }
        }.resume()
        
    }
    
    func setupViews()
    {
        self.view = (namelabel)
        namelabel <- [
            Left(10),
            Top(15)
        ]
    }
    
}

