//
//  DirectorListMoviesVC.swift
//  TableView_SEM3
//
//  Created by Urvish shah on 2017-07-17.
//  Copyright © 2017 MacStudent. All rights reserved.
//

import UIKit
import EasyPeasy
import AVFoundation
import AVKit
import Foundation

class DirectorListMoviesVC: UITableViewController{
    
var nameArray = [String]()
var imgArray = [String]()
public var dirName1: String!
    var titleNameDL = ""

    let urlString = "https://netflixroulette.net/api/api.php?director="
    
  // let finalString = "\(urlString) \(dirName1)"
    
override func viewDidLoad() {
    super.viewDidLoad()
    
    
    self.downloadJsonDataWithURL()
    
    navigationItem.title = "NetFlix Movies List"
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain , target: self, action: #selector(DirectorListMoviesVC.insert))
    
    
    self.tableView.register(DLMyCell.self, forCellReuseIdentifier: "cellId")
    self.tableView.register(DLHeader.self, forHeaderFooterViewReuseIdentifier: "headerId")
    tableView.sectionHeaderHeight = 50
}

func insert()
{
    print("HI")
    nameArray.append("List Cell  \(nameArray.count + 1)")
    imgArray.append("New \(imgArray.count + 1)")
    print (imgArray.count + 1)
    
    let insertionpath = NSIndexPath(row: nameArray.count - 1 , section: 0)
    
    
    tableView.insertRows(at: [insertionpath as IndexPath], with: .automatic)

}
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return nameArray.count
}

override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
    let myCell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! DLMyCell
    myCell.namelabel.text = nameArray[indexPath.row]
    
    let imgURL = NSURL(string: imgArray[indexPath.row])
    
    if imgURL != nil
    {
        let data = NSData(contentsOf: imgURL! as URL)
        myCell.imgButton.image = UIImage(data: data! as Data)
    }

    myCell.myTableViewController = self
    
    return myCell
}

override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerId")
}
    
    // Too navigate to details of Movies List
func navigatedetailMovie(cell: UITableViewCell){
    print("hiiiii")
    let detailMovie = MovieDetail() as UIViewController
    
    self.navigationController?.pushViewController(detailMovie, animated: true)
    
}

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        titleNameDL = nameArray[indexPath.row]
        
        let detailMovie = MovieDetail() as MovieDetail
        detailMovie.titleName = titleNameDL
        self.navigationController?.pushViewController(detailMovie, animated: true)
    }


override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == UITableViewCellEditingStyle.delete
    {
        nameArray.remove(at: indexPath.row)
        imgArray.remove(at: indexPath.row)
        
    }
    tableView.reloadData()
}
    

func downloadJsonDataWithURL()
{
    
    guard let finalString = "\(urlString)\(dirName1!)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
        return
    }
    let url = URL(string: finalString)
    URLSession.shared.dataTask(with: url!) { (data, response, error) in
        if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSArray
        {
            if let itemsArray = jsonObj as? Array<Dictionary<String,Any>>
                //.value(forKey: "actors") as? NSArray
            {
                for item in itemsArray
                {
                    if let itemDict = item as? Dictionary<String,Any>
                    {
                        if let name = itemDict["show_title"]
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
            }
            
        }
        }.resume()
    
}



}

class DLHeader : UITableViewHeaderFooterView
{
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let namelabel : UILabel = {
        let label = UILabel()
        label.text = "Director Movies"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    
    func setupViews()
    {
        addSubview(namelabel)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": namelabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": namelabel]))
    }
    
}

class DLMyCell : UITableViewCell
{
    
    // var label = UILabel()
    var myTableViewController: DirectorListMoviesVC?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    let namelabel : UILabel = {
        let label = UILabel()
        label.text = "Sample Item"
        //label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let actionButton : UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("Audio", for: .normal)
        
        //button.translatesAutoresizingMaskIntoConstraints = false
        //button.font = UIFont.boldSystemFont(ofSize: 5)
        return button
        
    }()
    
    
    let imgButton : UIImageView = {
        var img = UIImageView()
        return img
    }()
    
    func barItemTapped(sender : UIButton) {
        print("Helloooo")
    }
    func setupViews()
    {
        addSubview(namelabel)
        addSubview(actionButton)
        addSubview(imgButton)
      actionButton.addTarget(self, action: "handleaction", for: .touchUpInside)
        
        imgButton <- [
            Top(1),
            Left(10),
            Bottom(1),
            Width(80)
        ]
        
        namelabel <- [
            
            Left(10).to(imgButton),
            Top(15)
        ]
        
    }
    
    func handleaction()
    {
        myTableViewController?.navigatedetailMovie(cell: self)
    }
    
    
}
