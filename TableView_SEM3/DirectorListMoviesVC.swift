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

protocol MyCellDelegate {
    func btnNavTapped(myCell: DLMyCell)
    func btnFavTapped(myCell: DLMyCell)
}


class DirectorListMoviesVC: UITableViewController,MyCellDelegate{
    
    var titleNameDL = ""

  
   
var nameArray = [String]()
var imgArray = [String]()
public var dirName1: String!
    // For Favourite List
    var favListArray:NSMutableArray = []

    
    let urlString = "https://netflixroulette.net/api/api.php?director="
    
  // let finalString = "\(urlString) \(dirName1)"
 
    // View will Appear
//    override func viewWillAppear(_ animated: Bool) {
//        
//        super.viewWillAppear(animated)
//        
//        if UserDefaults.standard.object(forKey: "favList") != nil {
//            
//            favListArray = NSMutableArray.init(array: UserDefaults.standard.object(forKey: "favList") as! NSMutableArray)
//            
//        }
//        
//    }
    
    func btnNavTapped(myCell: DLMyCell) {
        let indexPath = self.tableView.indexPath(for: myCell)
        print(indexPath!.row)
        
        titleNameDL = nameArray[(indexPath?.row)!]
        
        let detailMovie = Detail() as Detail
        detailMovie.titleName = titleNameDL
        self.navigationController?.pushViewController(detailMovie, animated: true)
        
    }
    func btnFavTapped(myCell: DLMyCell) {
        let indexPath = self.tableView.indexPath(for: myCell)
        print(indexPath!.row)
        print ("New")
        
        
    }

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

//func btnCloseTapped(myCell: DLMyCell) {
//    //Get the indexpath of cell where button was tapped
//    let indexPath = self.collectionView.indexPathForCell(myCell)
//    print(indexPath!.row)
//}

//    func btnCloseTapped(cell: MyCell) {
//        //Get the indexpath of cell where button was tapped
//        let indexPath = self.DirectorListMoviesVC.indexPathForCell(cell)
//        print(indexPath!.row)
//    }
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
    myCell.delegate = self
    
    myCell.favouriteButton.tag = indexPath.row

    
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

    }
    
    // Swipe-able Table View Cell
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let more = UITableViewRowAction(style: .normal, title: "More") { action, index in
            print("more button tapped")
        }
        more.backgroundColor = .lightGray
        
        let favorite = UITableViewRowAction(style: .normal, title: "Favorite") { action, index in
            
            print("favorite button tapped")
           
        
        }
        favorite.backgroundColor = .orange
        
        let share = UITableViewRowAction(style: .normal, title: "Share") { action, index in
            print("share button tapped")
        }
        share.backgroundColor = .blue
        
        return [share, favorite, more]
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
    
    var favouriteButton : UIButton = {
        var button = UIButton(type: .system)
        let image = UIImage(named: "isDeSelectedFavourite.png")
        button.setBackgroundImage(image, for: .normal)
        return button
        
    }()
    var navButton : UIButton = {
        var button = UIButton(type: .system)
        let image = UIImage(named: "forward")
        button.setBackgroundImage(image, for: .normal)
        return button
        
    }()
    
   
    
    //2. create delegate variable
    var delegate: MyCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    //3. assign this action to close button
    func navButtonTapped(sender: AnyObject){
        //4. call delegate method
        //check delegate is not nil
        if let _ = delegate {
            delegate?.btnNavTapped(myCell: self)
        }
    }
    func favButtonTapped(sender: AnyObject){
        //4. call delegate method
        //check delegate is not nil
        if let _ = delegate {
            delegate?.btnFavTapped(myCell: self)
        }
    }
    
//    @IBAction func favouriteButtonTapped(sender: AnyObject){
//        //4. call delegate method
//        //check delegate is not nil
//        if let _ = MyCellDelegate {
//            MyCellDelegate?.btnCloseTapped(self)
//        }
//    }
    
    
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
       addSubview(favouriteButton)
        addSubview(imgButton)
        addSubview(navButton)
  
        favouriteButton.addTarget(self, action: "favaction", for: .touchUpInside)
        navButton.addTarget(self, action: #selector(MyCell.handleaction), for: .touchUpInside)
        //favouriteButton.addTarget(self, action: #selector(MyCell.), for: .touchUpInside)
        
        
        
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
        favouriteButton <- [
            
            Right(3).to(navButton),
            Top(15)
        ]
        navButton <- [
            Right(10),
            Top(15)
        ]

        
    }
    
    func handleaction()
    {
        myTableViewController?.btnNavTapped(myCell: self)
    }
    func favaction()
    {
        myTableViewController?.btnFavTapped(myCell: self)
    }
    
    
}
