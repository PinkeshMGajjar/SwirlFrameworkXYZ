//
//  VideoViewController.swift
//  AnalyticFramework
//
//  Created by Pinkesh Gajjar on 06/08/22.
//  Copyright © 2022 ProgrammingWithSwift. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class VideoViewController: UIViewController {
    
    @IBOutlet weak var viewMain: UIView!
    
    var player = AVPlayer()
    var playerController = AVPlayerViewController()
    var urlString: String = "https://stream.mux.com/bjV02JPwLJsTtJQmDsr8txqZTwvfW3xAkSj81rfsh9N00.m3u8"

    override func viewDidLoad() {
        super.viewDidLoad()

        //self.setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setUpView() {
        
        self.playVideo(videoUrl: urlString)
    }
    
    func playVideo(videoUrl: String) {
        
        let videoURL = NSURL(string: videoUrl)
        player = AVPlayer(url: videoURL! as URL)
        let playerController = AVPlayerViewController()
        playerController.player = player
        playerController.showsPlaybackControls = false
        self.addChild(playerController)
        playerController.view.frame = self.view.frame
        self.viewMain.addSubview(playerController.view)
        player.play()
    }
}
