//
//  DetailsViewController.swift
//  eMarkt
//
//  Created by Alex Codreanu on 28/06/2020.
//  Copyright © 2020 Alex Codreanu. All rights reserved.
//

import UIKit
import JGProgressHUD

class DetailsViewController: UIViewController {

    //MARK: - IBOutlets

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    //MARK: - Variables
    let hud: JGProgressHUD = JGProgressHUD(style: .dark)

    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_ :)), for: UIControl.Event.editingChanged)
        surnameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_ :)), for: UIControl.Event.editingChanged)
        addressTextField.addTarget(self, action: #selector(self.textFieldDidChange(_ :)), for: UIControl.Event.editingChanged)

    }
    
    
    //MARK: - IBActions
    @IBAction func doneButtonPressed(_ sender: Any) {
        finishOnboarding()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField){
        updateDoneButtonStatus()
    }
    
    
    //MARK: - Helper functions
    //EXPLANATION: - checking if the textfields have any text
    private func updateDoneButtonStatus(){
        if nameTextField.text != "" && surnameTextField.text != "" && addressTextField.text != "" {
            doneButton.backgroundColor = .none
            doneButton.isEnabled = true
        } else {
            doneButton.backgroundColor = .lightGray
            doneButton.isEnabled = false
        }
    }
    private func finishOnboarding() {
        let withValues = [kFIRSTNAME : nameTextField.text!, kLASTNAME : surnameTextField.text!, kONBOARD : true, kFULLADDRESS : addressTextField.text!, kFULLNAME : (nameTextField.text! + " " + surnameTextField.text!)] as [String : Any]
        updateCurrentUserInFirebase(withValues: withValues) { (error) in
            if error == nil {
                self.initJGProgressHUD(withText: "Updated details successfully!", typeOfIndicator: JGProgressHUDSuccessIndicatorView(), delay: 2.0)
            } else {
                print("Error updating user: ", error?.localizedDescription)
                self.initJGProgressHUD(withText: "Error: \(error?.localizedDescription)", typeOfIndicator: JGProgressHUDErrorIndicatorView(), delay: 2.0)
            }
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
    


}
