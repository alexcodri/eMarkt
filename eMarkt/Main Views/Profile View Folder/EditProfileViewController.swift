//
//  EditProfileViewController.swift
//  eMarkt
//
//  Created by Alex Codreanu on 28/06/2020.
//  Copyright © 2020 Alex Codreanu. All rights reserved.
//

import UIKit
import JGProgressHUD

class EditProfileViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    //MARK: - Variables
    let hud = JGProgressHUD(style: .dark)
    
    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadExistingUserInfo()
    }
    
    //MARK: - IBActions
    
    @IBAction func saveBarButtonPressed(_ sender: Any) {
        dismissKeyboard()
        if textFieldsHaveText(){
            
            let withValues = [kFIRSTNAME : nameTextField.text!, kLASTNAME : surnameTextField.text!, kFULLNAME : (nameTextField.text! + " " + surnameTextField.text!), kFULLADDRESS : addressTextField.text!] as [String : Any]
            
            updateCurrentUserInFirebase(withValues: withValues) { (error) in
                if error != nil {
                    self.initJGProgressHUD(withText: "There was an error: \(error?.localizedDescription)", typeOfIndicator: JGProgressHUDErrorIndicatorView(), delay: 2.0)
                    
                } else {
                    self.initJGProgressHUD(withText: "Fields were updated!", typeOfIndicator: JGProgressHUDSuccessIndicatorView(), delay: 2.0)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            initJGProgressHUD(withText: "All fields must have text!", typeOfIndicator: JGProgressHUDErrorIndicatorView(), delay: 2.0)
        }
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        logoutUser()
    }
    
    //MARK: - Update UI
    private func loadExistingUserInfo(){
        if MUser.currentUser() != nil {
            let currentUser = MUser.currentUser()!
            
            nameTextField.text = currentUser.firstName
            surnameTextField.text = currentUser.lastName
            addressTextField.text = currentUser.fullAddress
        }
    }
    
    
    //MARK: - JGProgress HUD creator
    private func initJGProgressHUD(withText: String?,typeOfIndicator: JGProgressHUDImageIndicatorView, delay: Double){
        //creating a JGProgressHUD
        self.hud.textLabel.text = withText
        self.hud.indicatorView = typeOfIndicator
        self.hud.show(in: self.view)
        self.hud.dismiss(afterDelay: delay)
    }
    
    
    //MARK: - Helper functions
    private func dismissKeyboard(){
        self.view.endEditing(false)
    }
    
    private func textFieldsHaveText() -> Bool{
        return (nameTextField.text != "" && surnameTextField.text != "" && addressTextField.text != "")
    }
    
    private func logoutUser(){
        MUser.logoutCurrentUser { (error) in
            if error != nil {
                print("error logging out!: \(error?.localizedDescription)")
            } else {
                print("Logged out")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}
