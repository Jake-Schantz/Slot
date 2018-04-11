//
//  ViewController.swift
//  SLOT
//
//  Created by Jacob Schantz on 4/8/18.
//  Copyright © 2018 Jake Schantz. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseAuth


class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    var paused: Bool = true
    
    
    func addBlurBackgroundView() {
        var bluredView: UIVisualEffectView = UIVisualEffectView.init()
        let blurEffect = UIBlurEffect.init(style: .light)
        bluredView = UIVisualEffectView.init(effect: blurEffect)
        bluredView.alpha = 0.5
        bluredView.frame = view.frame
        view.addSubview(bluredView)
    }
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text
            else {return}
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if let validError = error {
                self.alert("Error", validError.localizedDescription)
            }
            
            if let _ = user {
                NotificationCenter.appLogin()
            }
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard let signUpVC = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController
            else{return}
        navigationController?.pushViewController(signUpVC, animated: true)
    }

    
    override func viewDidLoad() {
        self.hideKeyboard()
        initatePlayer()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let textAttributes = [NSAttributedStringKey.foregroundColor: Slot.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = .white
        
        
        
        loginButton.layer.cornerRadius = 18
        self.createGradientLayer(inputView: loginButton)
        
        passwordTextField.makePlaceHolderWhite("Password")
        emailTextField.makePlaceHolderWhite("Email")
        passwordTextField.customizeAuth()
        emailTextField.customizeAuth()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addKeyboardObserver()
        self.navigationController?.navigationBar.isHidden = true
        invertPlayer()
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.removeKeyboardObserver()
        invertPlayer()
        super.viewWillDisappear(animated)
    }
    
    
    // Video Background Functions
    func initatePlayer(){
        // None of our movies should interrupt system music playback.
        _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
        
        let URL = Bundle.main.url(forResource: "Lights", withExtension: "mp4")
        avPlayer = AVPlayer(url: URL!)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avPlayer.volume = 0
        avPlayer.actionAtItemEnd = .none
        avPlayerLayer.frame = view.layer.bounds
        view.backgroundColor = .clear
        view.layer.insertSublayer(avPlayerLayer, at: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem)
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        let playerItem: AVPlayerItem = notification.object as! AVPlayerItem
        playerItem.seek(to: kCMTimeZero, completionHandler: nil)
    }
    
    func invertPlayer(){
        if paused {
            avPlayer.play()
        }
        else {
            avPlayer.pause()
        }
        paused = !paused
    }
}
