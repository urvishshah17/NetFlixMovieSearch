//
//  VideoPlayVC.swift
//  TableView_SEM3
//
//  Created by Urvish shah on 2017-05-31.
//  Copyright © 2017 MacStudent. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoPlayVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let videoURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
        
//        func dismissmain()
//        {
            navigationController?.popViewController(animated: true)
        //}

        
        // Do any additional setup after loading the view.
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
