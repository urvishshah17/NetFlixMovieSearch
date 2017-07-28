//
//  ViewController.swift
//  TableView_SEM3
//
//  Created by MacStudent on 2017-05-15.
//  Copyright © 2017 MacStudent. All rights reserved.
//

import UIKit
import EasyPeasy
import AVFoundation
import AVKit

class MyTableViewController: UITableViewController{
    
        var nameArray = [String]()
        var imgArray = [String]()
        var dirName = ""
        //let urlString = "https://api.github.com/search/users?q=tom"
        //let urlString = "http://microblogging.wingnity.com/JSONParsingTutorial/jsonActors"
         // let urlString = "http://netflixroulette.net/api/api.php?director=Quentin%20Tarantino"
           // let urlString = "https://netflixroulette.net/api/api.php?director="
    let urlString = "https://netflixroulette.net/api/api.php?actor=Nicolas%20Cage"
        override func viewDidLoad() {
        super.viewDidLoad()
        
        
               self.downloadJsonDataWithURL()
         
            
        navigationItem.title = "NetFlix Movies List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain , target: self, action: #selector(MyTableViewController.insert))
            
            
        self.tableView.register(MyCell.self, forCellReuseIdentifier: "cellId")
        self.tableView.register(Header.self, forHeaderFooterViewReuseIdentifier: "headerId")
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dirName = nameArray[indexPath.row]
        
        let dlMoviesVC = DirectorListMoviesVC() as DirectorListMoviesVC
        dlMoviesVC.dirName1 = dirName
        self.navigationController?.pushViewController(dlMoviesVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! MyCell
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
    
    /* Function to handel click event */
    func navigate(cell: UITableViewCell){
        print("hiiiii")
        let secondVC = LIstVC() as UIViewController
        
        self.navigationController?.pushViewController(secondVC, animated: true)
        
    }
    
    func navigateDLMovies(cell: MyCell){
        
        let dlMoviesVC = DirectorListMoviesVC() as DirectorListMoviesVC
        dlMoviesVC.dirName1 = dirName
        self.navigationController?.pushViewController(dlMoviesVC, animated: true)
    }
    
    
    /* End of Function to handel click event */
    
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
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSArray
            {
                //print(jsonObj?.value(forKey: "actors"))
                print(jsonObj!)
                if let itemsArray = jsonObj! as? NSArray
                    //.value(forKey: "actors") as? NSArray
                {
                        for item in itemsArray
                        {
                            if let itemDict = item as? NSDictionary
                            {
                                if let name = itemDict.value(forKey: "director")
                                {
                                    self.nameArray.append(name as! String)
                                }
                                
                                if let image = itemDict.value(forKey: "poster")
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

class Header : UITableViewHeaderFooterView
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
        label.text = "DIRECTORS"
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

class MyCell : UITableViewCell
{
    
   // var label = UILabel()
    var myTableViewController: MyTableViewController?
    
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
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    

    let videoButton : UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("Video", for: .normal)
        return button
        
    }()
    let imgButton : UIImageView = {
        var img = UIImageView()
        return img
    }()
    
    func barItemTapped(sender : UIButton) {
        //Write button action here
        print("Helloooo")
           }
    func setupViews()
    {
        addSubview(namelabel)
        addSubview(imgButton)
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
        myTableViewController?.navigate(cell: self)
    }
    func handlevideo()
    {
        myTableViewController?.navigateDLMovies(cell: self)
    }

}
