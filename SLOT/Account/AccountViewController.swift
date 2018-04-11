//
//  AccountViewController.swift
//  SLOT
//
//  Created by Jacob Schantz on 4/10/18.
//  Copyright © 2018 Jake Schantz. All rights reserved.
//


import UIKit
import AVKit
import FirebaseAuth


class AccountViewController: UIViewController {
    
    
    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    var paused: Bool = true
    var tableView = UITableView()
    var titles: [String] = ["First Name", "Last Name", "Email Address", "Phone Number", "License Plate Number", "Credit Card Info"]
    
    
    func createTableView(){
        tableView.frame = CGRect(x: 0, y: 64, width: view.frame.width, height: view.frame.height-64)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .clear
        self.view.addSubview(tableView)
    }
    
    
    func createLogOutButton() {
        let logOutButton = UIBarButtonItem(title: "Log Out", style: .done, target: self, action: #selector(logOutButtonTapped))
        navigationItem.rightBarButtonItem = logOutButton
    }
    @objc func logOutButtonTapped() {
        do {
            try Auth.auth().signOut()
            NotificationCenter.appLogout()
        } catch {}
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initatePlayer()
        self.addDarkBlurEffect(to: self.view)
        createNavBar()
        createLogOutButton()
        createTableView()
        CurrentUser.fetchInfoFromDatabase {
            DispatchQueue.main.async {
                CurrentUser.grabInfo()
                self.tableView.reloadData()
            }
        }
    }
}

extension AccountViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return createLabels(for: indexPath)
    }
}

extension AccountViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let editVC = storyboard?.instantiateViewController(withIdentifier: "EditViewController") as? EditViewController
            else{return}
        let title = titles[indexPath.row]
        editVC.selectedTitle = title
        present(editVC, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
