//
//  AcountUI.swift
//  SLOT
//
//  Created by Jacob Schantz on 4/11/18.
//  Copyright © 2018 Jake Schantz. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import FirebaseAuth


extension AccountViewController {
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        avPlayer.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        avPlayer.pause()
    }
    
    
    func createNavTitle(){
        let imageView = UIImageView(image: UIImage(named: "account(white)"))
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 110, height: 25))
        imageView.frame = titleView.bounds
        titleView.addSubview(imageView)
        self.navigationItem.titleView = titleView
    }
    
    
    func addDarkBlurEffect(to inputView: UIView) {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        visualEffectView.frame = inputView.frame
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        inputView.insertSubview(visualEffectView, at: 2)
    }
    
    
    func createNavBar(){
//        createNavTitle()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let textAttributes = [NSAttributedStringKey.foregroundColor: Slot.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = .white
//        self.title = "Account Info"
        
        let gradientView = UIView()
        gradientView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 64)
        gradientView.backgroundColor = Slot.lightBlue
        self.view.insertSubview(gradientView, at: 1)
    }
    
    
    func createLabels(for indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.selectionStyle = .default
        cell.backgroundColor = .clear
        
        let titleLabel = UILabel(frame: CGRect(x: 15, y: 25, width: tableView.bounds.size.width, height: 20))
        titleLabel.font = UIFont(name: Slot.fontString, size: 20)
        titleLabel.textColor = UIColor.white
        titleLabel.text = titles[indexPath.row]
        titleLabel.sizeToFit()
        
        
        cell.accessoryType = .disclosureIndicator
        let px = 1 / UIScreen.main.scale
        let border = UIView(frame: CGRect(x: 15, y: 51, width: self.view.bounds.width-70, height: px))
        border.backgroundColor = Slot.blue
        
        let cellLabel = UILabel(frame: CGRect(x: 15, y: 56, width: tableView.bounds.size.width, height: 40))
        cellLabel.font = UIFont(name: Slot.fontString, size: 20)
        cellLabel.textColor = UIColor.white
        var text = CurrentUser.contentDictionary[titles[indexPath.row]]!
        if titles[indexPath.row] == "Credit Card Info" && text != "" {
            let last4 = text.suffix(4)
            text = "**** **** **** \(last4)"
        }
        cellLabel.text = text
        cellLabel.sizeToFit()
        
        cell.contentView.addSubview(titleLabel)
        cell.contentView.addSubview(border)
        cell.contentView.addSubview(cellLabel)
        return cell
    }
    
    
    
    // Video Background Functions
    func initatePlayer(){
        // None of our movies should interrupt system music playback.
        _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
        let URL = Bundle.main.url(forResource: "flippedBlue", withExtension: "mp4")
        avPlayer = AVPlayer(url: URL!)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avPlayer.volume = 0
        avPlayer.actionAtItemEnd = .none
        avPlayerLayer.frame = view.layer.bounds
        view.backgroundColor = .clear
        view.layer.insertSublayer(avPlayerLayer, at: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem)
    }
    @objc func applicationDidBecomeActive() {
        if self.viewIfLoaded?.window != nil {
            avPlayer.play()
        }
    }
    @objc func playerItemDidReachEnd(notification: Notification) {
        let playerItem: AVPlayerItem = notification.object as! AVPlayerItem
        playerItem.seek(to: kCMTimeZero, completionHandler: nil)
    }
}
