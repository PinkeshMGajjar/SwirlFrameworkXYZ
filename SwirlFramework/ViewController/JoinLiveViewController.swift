//
//  JoinLiveViewController.swift
//  SwirlFramework
//
//  Created by Pinkesh Gajjar on 08/08/22.
//

import UIKit
import Foundation
import IQKeyboardManagerSwift
import AVFoundation
import AVKit
import Firebase
import ObjectMapper
import SwiftyJSON

class JoinLiveViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var viewPinLastComment: UIView!
    @IBOutlet weak var viewProductList: UIView!
    @IBOutlet weak var viewAskQuestion: UIView!
    @IBOutlet weak var viewShowMe: UIView!
    @IBOutlet weak var viewLiveChat: UIView!
    @IBOutlet weak var btnCloseLiveShow: DesignableButton!
    @IBOutlet weak var btnMute: DesignableButton!
    @IBOutlet weak var imgViewMute: UIImageView!
    @IBOutlet weak var btnShareLink: DesignableButton!
    @IBOutlet weak var viewMainVideo: UIView!
    @IBOutlet weak var viewBottomButton: DesignableView!
    @IBOutlet weak var viewBottomAlpha: UIView!
    
    @IBOutlet weak var tableViewProductList: UITableView!
    @IBOutlet weak var tableViewAskQuestion: UITableView!
    @IBOutlet weak var tableViewShowMe: UITableView!
    @IBOutlet weak var tableViewComment: UITableView!
    
    @IBOutlet weak var btnCloseProductListView: DesignableButton!
    @IBOutlet weak var lblProductListTitle: UILabel!
    @IBOutlet weak var btnCloseAskQueView: DesignableButton!
    @IBOutlet weak var lblAskQueTitle: UILabel!
    @IBOutlet weak var btnCloseShowMeView: DesignableButton!
    @IBOutlet weak var lblShowMeTitle: UILabel!
    @IBOutlet weak var btnCloseLiveChatView: DesignableButton!
    @IBOutlet weak var lblLiveChatTitle: UILabel!
    @IBOutlet weak var btnSendMessage: DesignableButton!
    @IBOutlet weak var tfSendMessage: DesignableTextField!
    
    @IBOutlet weak var btnProductList: MIBadgeButton!
    @IBOutlet weak var btnAskQuestion: MIBadgeButton!
    @IBOutlet weak var btnShowMe: MIBadgeButton!
    @IBOutlet weak var btnShowChat: DesignableButton!
    
    @IBOutlet weak var viewScheduleLive: UIView!
    @IBOutlet weak var txtViewAskQuestion: DesignableTextView!
    
    @IBOutlet weak var imgViewThumbnail: DesignableImageView!
    @IBOutlet weak var lblLiveStreamTitle: UILabel!
    @IBOutlet weak var lblLiveStreamis: UILabel!
    @IBOutlet weak var lblStartingSoon: UILabel!
    @IBOutlet weak var lblTimeDate: UILabel!
    
    
    let databaseCollectionForMessage = Firestore.firestore().collection("messages")
    let databaseCollectionForLiveStream = Firestore.firestore().collection("live_streams")
    
    var comments = [Comment].init()
    var arrayOfTempComment = [Comment].init()
    var isCommentFound: Bool = false
    
    var messageCount: Int = 0
    
    var player = AVPlayer()
    var playerController = AVPlayerViewController()
    var urlString: String = "https://stream.mux.com/Pt4mqFuMaXx8021jXPiTsMEEZ5vl2RGzKnxTD02LxhnPY.m3u8"
    var streamId: String = "A00cBcX02MN3ybGJGxyYdl9ABUfu023GIWnt6zMuaHD0000k"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        self.fetchCommentData(streamId: self.streamId)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        player.pause()
        player.replaceCurrentItem(with: nil)
    }
    
    func setUpView() {
        
        NotificationCenter.default.addObserver(self,selector:#selector(liveStreamSelected(_:)),
                         name: NSNotification.Name ("NotificationIdentifier"), object: nil)
        
        self.viewProductList.isHidden = true
        self.viewShowMe.isHidden = true
        self.viewAskQuestion.isHidden = true
        self.viewLiveChat.isHidden = true
        self.setUpTableView()
        self.txtViewAskQuestion.placeHolderText = "Type your question here"
        self.playVideo(videoUrl: urlString)
    }
    
    @objc func liveStreamSelected(_ notification: Notification) {

        print(notification.userInfo?["userInfo"] as? [String: Any] ?? [:])
        let discTemp = notification.userInfo?["userInfo"] as? [String: Any]
        let id = discTemp?["userID"] as? Int ?? 0
        
        if id != 0 {
            self.viewScheduleLive.isHidden = false
        } else {
            self.viewScheduleLive.isHidden = true
        }
    }
    
    func playVideo(videoUrl: String) {
        
        let videoURL = NSURL(string: videoUrl)
        player = AVPlayer(url: videoURL! as URL)
        let playerController = AVPlayerViewController()
        playerController.player = player
        playerController.showsPlaybackControls = false
        self.addChild(playerController)
        playerController.view.frame = self.view.frame
        self.viewMainVideo.addSubview(playerController.view)
        player.play()
    }
    
    func setUpTableView() {
        
        self.tableViewComment.delegate = self
        self.tableViewComment.dataSource = self
        self.tableViewComment.tableFooterView = UIView.init()
        //self.tableViewComment.transform = CGAffineTransform(scaleX: 1, y: -1)
        self.tableViewComment.isHidden = true
    }
    
    func addCommentData(data: [String:Any]) {
        
        var singleComment = Comment()
        singleComment.user_phone = data["user_phone"] as? String
        singleComment.profile = data["profile"] as? String
        singleComment.type = data["type"] as? String
        singleComment.is_designer = data["is_designer"] as? Bool
        singleComment.is_designer_seen = data["is_designer_seen"] as? Bool
        //singleComment.flag = data["flag"] as? String
        singleComment.title = data["title"] as? String
        singleComment.name = data["name"] as? String
        singleComment.message = data["message"] as? String
        singleComment.from = data["from"] as? String
        singleComment.cover_img = data["cover_img"] as? String
        singleComment.created_time = data["created_time"] as? Int
        self.comments.append(singleComment)
    }
    
    func deleteCommentData(data: [String:Any]) {
        
        var singleComment = Comment()
        singleComment.user_phone = data["user_phone"] as? String
        singleComment.profile = data["profile"] as? String
        singleComment.type = data["type"] as? String
        singleComment.is_designer = data["is_designer"] as? Bool
        singleComment.is_designer_seen = data["is_designer_seen"] as? Bool
        //singleComment.flag = data["flag"] as? String
        singleComment.title = data["title"] as? String
        singleComment.name = data["name"] as? String
        singleComment.message = data["message"] as? String
        singleComment.from = data["from"] as? String
        singleComment.cover_img = data["cover_img"] as? String
        singleComment.created_time = data["created_time"] as? Int
        let deleteCommentIndex = self.comments.firstIndex { $0 == singleComment} ?? 0
        self.comments.remove(at: deleteCommentIndex)
    }
    
    func fetchCommentData(streamId: String) {
        //self.databaseCollectionForMessage.document(streamId).collection("messages").order(by: "created_time")
        //self.databaseCollectionForMessage.document(streamId).collection("messages").whereField("type", isEqualTo: "text")
        self.databaseCollectionForMessage.document(streamId).collection("messages").order(by: "created_time")
        .addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            print("From fetchCommentData count : ", snapshot.count)
            
            if snapshot.count > 0 {
                self.isCommentFound = true
                if snapshot.documents.count > 0 {
                    if snapshot.documentChanges.count > 0 {
                        snapshot.documentChanges.forEach { diff in
                            if (diff.type == .added) {
                                self.addCommentData(data: diff.document.data())
                                print("From Added Comment Data : ",diff.document.data())
                            }
                            if (diff.type == .modified) {
                                //self.comments.append(diff.document.data())
                                print("From Modified Comment Data : ",diff.document.data())
                            }
                            if (diff.type == .removed) {
                                print("From comment document removed : \(diff.document.data())")
                                self.deleteCommentData(data: diff.document.data())
                                //self.showCurrentAndPinComment()
                                self.tableViewComment.reloadData()
                            }
                        }
                    }
                }
            } else {
                self.isCommentFound = false
                //self.deleteAllComment()
            }
            
            //self.arrayOfTempComment = Array(self.comments.reversed())
            self.arrayOfTempComment = Array(self.comments)
            if self.arrayOfTempComment.count > 0 {
                print("From Last Message : ", self.arrayOfTempComment.first as Any)
                //self.showCurrentAndPinComment()
                self.tableViewComment.isHidden = false
                
            }
        
            self.tableViewComment.reloadData()
            
            if self.arrayOfTempComment.count > 0 {
                print("From Table Scroll Bottom... ")
                self.tableViewScrollBottom()
            }
        }
    }
    
    func tableViewScrollBottom() {
        
        UIView.animate(withDuration: 0.2, delay: 0.1, options: .transitionFlipFromBottom, animations: {
            self.tableViewComment.reloadData()
            if self.arrayOfTempComment.count > 0 {
                self.tableViewComment.scrollToBottom(isAnimated: false)
            }
        }, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.tfSendMessage {
           
        }
    }
    
    func hideAndShowView(showView: UIView) {
        
        self.viewShowMe.isHidden = true
        self.viewLiveChat.isHidden = true
        self.viewAskQuestion.isHidden = true
        self.viewProductList.isHidden = true
        
        showView.isHidden = false
    }
    
    @IBAction func btnProductList(_ sender: UIButton) {
        
        self.hideAndShowView(showView: self.viewProductList)
    }
    
    @IBAction func btnAskQuestion(_ sender: UIButton) {
        
        self.hideAndShowView(showView: self.viewAskQuestion)
    }
    
    @IBAction func btnShowMe(_ sender: UIButton) {
        
        self.hideAndShowView(showView: self.viewShowMe)
    }
    
    @IBAction func btnShowChat(_ sender: UIButton) {
        
        self.hideAndShowView(showView: self.viewLiveChat)
    }
    
    @IBAction func btnMute(_ sender: UIButton) {
        
        if sender.isSelected {
            print("From Selected ...")
            player.isMuted = false
            self.imgViewMute.image = UIImage(named: "unmute", in: Bundle(identifier: "com.goswirl.SwirlFramework"), compatibleWith: nil)
        } else {
            print("From Not Selected ...")
            player.isMuted = true
            self.imgViewMute.image = UIImage(named: "mute", in: Bundle(identifier: "com.goswirl.SwirlFramework"), compatibleWith: nil)
        }
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func btnShareLink(_ sender: UIButton) {
        
        let items = ["Work from home"]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
        
//        if let stringURL = self.labelShareMyStore.text {
//            let items = [stringURL]
//            let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
//            present(ac, animated: true)
//        } else {
//            let alert = UIAlertController(title: "", message: "No link available ..!", preferredStyle: .alert)
//            self.present(alert, animated: true, completion: nil)
//            let when = DispatchTime.now() + 2
//            DispatchQueue.main.asyncAfter(deadline: when){
//              alert.dismiss(animated: true, completion: nil)
//            }
//        }
    }
    
    @IBAction func btnCloseLiveShow(_ sender: UIButton) {
        
        self.dismiss(animated: true)
    }
    
    @IBAction func btnCloseProductListView(_ sender: UIButton) {
        
        self.viewProductList.isHidden = true
    }
    
    @IBAction func btnCloseAskQueView(_ sender: UIButton) {
        
        self.viewAskQuestion.isHidden = true
    }
    
    @IBAction func btnCloseShowMeView(_ sender: UIButton) {
        
        self.viewShowMe.isHidden = true
    }
    
    @IBAction func btnCloseLiveChatView(_ sender: UIButton) {
        
        self.viewLiveChat.isHidden = true
    }
    
    func createDocument() {
        
        self.databaseCollectionForMessage.document(self.streamId).setData([
            "stream_id": self.streamId
        ])
    }
    
    @IBAction func btnSendMessage(_ sender: UIButton) {
        
        self.dismissKeyboard()
        guard let message = self.tfSendMessage.text, !message.isEmpty else {
            return
        }
        
        self.messageCount = self.messageCount + 1
        self.createDocument()
        let currntTime = Int(NSDate().timeIntervalSince1970 * 1000)
        let fullName = "SDK Tester"
        self.databaseCollectionForMessage.document(self.streamId).collection("messages").addDocument(data: [
            "from": "SDK Tester",
            "message": message,
            "type": "text",
            "created_time":currntTime,
            "is_designer": true,
            "is_user": false,
            "name": fullName,
            "profile": Constants.getUserDetails(key: "profile"),
            "user_phone": Constants.getUserDetails(key: "user_phone"),
            "is_designer_seen": true,
            "is_user_seen": true,
            "cover_img": "",
            "title": Constants.liveNowTitle,
            "index": self.messageCount
        ])
        self.tfSendMessage.text = nil
    }
}

extension JoinLiveViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrayOfTempComment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        let comment = self.arrayOfTempComment[indexPath.row]
        let replyFrom = comment.name
        let message = comment.message
        
        //let messageFromString = comment.from ?? ""
        //let messageFrom = Int(messageFromString)
        
        let normalText = " : " + (message?.trim() ?? "")
        let attrsSimple = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)]
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
        let boldUserName = NSMutableAttributedString(string: replyFrom!, attributes:attrs)
        let normalString = NSMutableAttributedString(string: normalText, attributes:attrsSimple)
        let attributedString = NSMutableAttributedString(attributedString: boldUserName)
        attributedString.append(normalString)
        cell.lblMessage.attributedText = attributedString
        cell.lblMessage.textColor = UIColor.black
        cell.viewLblMessage.alpha = 1
        //let userID = comment["from"] as? String ?? ""
        //cell.configCell(userId: userID)
        //cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
    }
    
    
    
}
