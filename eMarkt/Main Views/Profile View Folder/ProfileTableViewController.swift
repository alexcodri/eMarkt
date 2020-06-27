//
//  ProfileTableViewController.swift
//  eMarkt
//
//  Created by Alex Codreanu on 28/06/2020.
//  Copyright © 2020 Alex Codreanu. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var finishRegistrationButton: UIButton!
    @IBOutlet weak var purchaseHistoryButton: UIButton!
    
    //MARK: - Variables
    var editButtonOutlet: UIBarButtonItem!
    
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //check logged in status
        checkLoginStatus()
        checkOnBoardingStatus()
    }
    
    // MARK: - Table view data source
    //EXPLANATION: - having only static cells, there is need for only one function
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    //MARK: - Tableview delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    //MARK: - Helper functions
    private func checkLoginStatus(){
        if MUser.currentUser() == nil {
            //EXPLANATION: - there is no current user so a login button will appear
            createRightBarButtonWith(title: "Login")
        } else {
            createRightBarButtonWith(title: "Edit")
        }
    }
    
    private func createRightBarButtonWith(title: String){
        editButtonOutlet = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(rightBarButtonItemPressed))
        self.navigationItem.rightBarButtonItem = editButtonOutlet
    }
    
    private func checkOnBoardingStatus() {
        if MUser.currentUser() != nil {
            
            if MUser.currentUser()!.onBoard {//EXPLANATION: - if the user has all data completed
                finishRegistrationButton.setTitle("Registration finished!", for: .normal)
                finishRegistrationButton.setTitleColor(UIColor.black, for: .normal)
                finishRegistrationButton.isEnabled = false
            } else {
                //EXPLANATION: - the user does not have all the data 
                finishRegistrationButton.setTitle("Finish registration", for: .normal)
                finishRegistrationButton.setTitleColor(UIColor.red, for: .normal)
                finishRegistrationButton.isEnabled = true
            }
        } else {
            //EXPLANATION: - Disabling the buttons when the user is logged out
            finishRegistrationButton.setTitle("Logged out", for: .normal)
            finishRegistrationButton.isEnabled = false
            purchaseHistoryButton.isEnabled = false
        }
    }
    //MARK: - IBActions
    
    @objc func rightBarButtonItemPressed(){
        if editButtonItem.title == "Login"{
            //EXPLANATION: - show login view
            showLoginView()
        } else {
            //EXPLANATION: - go to user's profile
            goToEditUserProfile()
        }
    }
    
    private func showLoginView() {
        let loginView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "loginView")
        self.present(loginView, animated: true, completion: nil)
    }
    
    private func goToEditUserProfile() {
    
        performSegue(withIdentifier: "profileToEditSegue", sender: self)
    }
}
