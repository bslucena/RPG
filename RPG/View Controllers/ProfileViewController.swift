//
//  ProfileViewController.swift
//  RPG
//
//  Created by Bernardo Sarto de Lucena on 12/28/17.
//  Copyright © 2017 Bernardo Sarto de Lucena. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage


class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    let cellId = "cellId"
    var users = [Users]()
    var messages = [Message]()
    let chatController = ChatLogController(collectionViewLayout: UICollectionViewLayout())
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        //let image = UIImage(named: "messageIcon")
        //navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "messageIcon"), style: .plain, target: self, action: #selector(handleFeed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Feed", style: .plain, target: self, action: #selector(handleFeed))
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        messageTableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.cornerRadius = 70
        profileImageView.clipsToBounds = true
        
        fetchCurrentUser()
        checkIfUserIsLoggedIn()
        
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        self.navigationItem.titleView = titleView
        
        // codigo para mostrar as mensagens em vez de lista de contatos
        //observeMessages()
        
    }
    
    func checkIfUserIsLoggedIn() {
        
        let userId = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(userId!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                //the code below is to put the name of the user on the navigation bar.
                //self.navigationItem.title = dictionary["name"] as? String
                if let profileImageUrl = dictionary["profileImageUrl"] {
                    self.profileImageView.image = self.imageDownloader(imageURL: URL(string: profileImageUrl as! String)!)
                }
                self.nameLabel.text = dictionary["name"] as? String
                
            }
        }, withCancel: nil)
        
    }
    
    @objc func handleFeed() {
        let newMessageController = FeedViewController()
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
    
    func observeMessages() {
        
        let ref = Database.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                print(snapshot)
                
//                let message = Message()
//                message.setValuesForKeys(dictionary)
//                print(message.text)
//                self.messages.append(message)
//
//                self.messageTableView.reloadData()
            }
            
        }, withCancel: nil)
        
    }
    
    func fetchCurrentUser() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = Users(dictionary: dictionary)
                user.id = snapshot.key
                
                print(snapshot)
                //user.setValuesForKeys(dictionary)
                self.users.append(user)
                
                DispatchQueue.main.async(execute: {
                self.messageTableView.reloadData()
                })
            }
            
        }, withCancel: nil)
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch _ {
            print("Something went wrong!")
        }
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        //self.performSegue(withIdentifier: "LogOutToLogInPage", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)-> Int {
        //return users.count
        // codigo para mostrar as mensagens em vez da lista de contato.
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = messageTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let user = users [indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        if let profileImageUrl = user.profileImageUrl {

        cell.contactImageView.loadImageUsingCacheWithUrlString(profileImageUrl)

        }

        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let user = self.users[indexPath.row]
        chatController.user = user
        showChatController(user: user)
    }
    
    @objc func showChatController(user: Users) {
        
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
        
    }
    
    func popAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }

    func imageDownloader(imageURL: URL) -> UIImage {
        var picture: UIImage = UIImage()
        let data = try? Data(contentsOf: imageURL)
        
        if let _ = data {
            let image = UIImage(data: data!)
            picture = image!
        }
        
        return picture
    }
    
}


