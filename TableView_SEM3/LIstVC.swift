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


class LIstVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        
//        self.view.backgroundColor = UIColor.lightGray
//        
//        let textlabel = UILabel()
//        self.view.addSubview(textlabel)
//        textlabel.text = "WEL-COME"
//        
//        textlabel <- [
//            Bottom(475),
//            Left(1)
//        ]
        
        
        
        // Do any additional setup after loading the view.
        // PHOTO LIBRARRY CODE START
        let picker = UIImagePickerController()
        
        picker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        
        present(picker, animated: true,completion: nil)
        
        //PHOTO LIBRARAY CODE ENDS
       
        
        navigationController?.popViewController(animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
