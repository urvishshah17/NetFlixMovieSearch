//
//  Detail.swift
//  TableView_SEM3
//
//  Created by Urvish shah on 2017-08-08.
//  Copyright © 2017 MacStudent. All rights reserved.
//

import UIKit

class Detail: UIViewController {

    var nameArray = [String]()
       public var titleName: String!
    
    let urlString = "http://netflixroulette.net/api/api.php?title="
    
    let namelabel = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 210))
    let imgButton = UIImageView(frame: CGRect(x: 0, y: 0, width: 250, height: 210))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        downloadJsonDataWithURL()
       
        imgButton.center = CGPoint(x:160, y:185)
        
        namelabel.center = CGPoint(x: 160, y: 300)
        namelabel.textAlignment = .center
        
        self.view.addSubview(imgButton)
        self.view.addSubview(namelabel)
    }

    // Getting Data using Json Object from API by getting title name from previous Screen and combine it to Final URL.
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
                // Get Summary of MovieTitle
                let summary = jsonObj?["summary"] as? String
                DispatchQueue.main.async {
                    self.namelabel.text = summary
                }
                // Get Title Poster
                let image = jsonObj?["poster"] as? String; DispatchQueue.main.async {
                    let imgURL = NSURL(string: image!)

                    if imgURL != nil
                    {
                        let data = NSData(contentsOf: imgURL! as URL)
                        self.imgButton.image = UIImage(data: data! as Data)
                    }

                    
                }

                
            }
            }.resume()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
}
