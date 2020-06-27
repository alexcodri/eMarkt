//
//  WelcomeViewController.swift
//  eMarkt
//
//  Created by Alex Codreanu on 27/06/2020.
//  Copyright © 2020 Alex Codreanu. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import JGProgressHUD
class WelcomeViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var resendButton: UIButton!
    
    //MARK: - Variables
    
    let hud = JGProgressHUD(style: .dark)
    var activityIndicator: NVActivityIndicatorView?


    //MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60.0, height: 60.0), type: .ballPulse, color: .black, padding: nil)
    }
    
    //MARK: - IBActions

    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismissView()
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if textFieldsHaveText(){ //EXPLANATION: - checking if the fields are empty
            loginUser()
        } else {
            initJGProgressHUD(withText: "All fields are required!", typeOfIndicator: JGProgressHUDErrorIndicatorView(), delay: 2.0)
        }
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        if textFieldsHaveText(){ //EXPLANATION: - checking if the fields are empty
            registerUser()
        } else {
            initJGProgressHUD(withText: "All fields are required!", typeOfIndicator: JGProgressHUDErrorIndicatorView(), delay: 2.0)
        }
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        if emailTextField.text != "" {
            resetPassword()
        } else {
            initJGProgressHUD(withText: "Please insert email!", typeOfIndicator: JGProgressHUDErrorIndicatorView(), delay: 2.0)
        }
    }
    
    @IBAction func resendEmailButtonPressed(_ sender: Any) {
        MUser.resendVerificationEmail(email: emailTextField.text!) { (error) in
            if error == nil {
                print("Error resending verification email!", error?.localizedDescription)
                self.initJGProgressHUD(withText: "Error resending verification email!", typeOfIndicator: JGProgressHUDErrorIndicatorView(), delay: 2.0)
            } else {
                self.initJGProgressHUD(withText: "Verification email was sent!", typeOfIndicator: JGProgressHUDSuccessIndicatorView(), delay: 2.0)
            }
        }
    }
    //MARK: - Register user
    private func registerUser() {
        showLoadingIndicator()
        MUser.registerUser(email: emailTextField.text!, password: passwordTextField.text!) { (error) in
            
            if error == nil {
                self.initJGProgressHUD(withText: "Email verification sent!",
                                       typeOfIndicator: JGProgressHUDSuccessIndicatorView(), delay: 2.0)
            } else {
                print("Error registring user!", error!.localizedDescription)
                self.initJGProgressHUD(withText: "There was an error: \(error!.localizedDescription)",
                                       typeOfIndicator: JGProgressHUDErrorIndicatorView(), delay: 2.0)
            }
        }
        self.hideLoadingIndicator()
    }
    
    //MARK: - Login user
    private func loginUser(){
        showLoadingIndicator()
        MUser.loginUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error, isEmailVerified) in
            
            if error == nil {
                if isEmailVerified{
                    self.dismissView()
                    print("Email is verified!")
                } else {
                    self.initJGProgressHUD(withText: "Please verify your email!", typeOfIndicator: JGProgressHUDErrorIndicatorView(), delay: 2.0)
                    self.resendButton.isHidden = false
                }
            } else {
                print("Error loggin in the user: \(error!.localizedDescription)")
                self.initJGProgressHUD(withText: "Error: \(error!.localizedDescription)", typeOfIndicator: JGProgressHUDErrorIndicatorView(), delay: 2.0)
            }
            self.hideLoadingIndicator()
        }
    }

    //MARK: - Function helpers
    private func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    private func textFieldsHaveText() -> Bool {
        return (emailTextField.text != "" && passwordTextField.text != "")
    }
    
    private func resetPassword(){
        MUser.resetPasswordFor(email: emailTextField.text!) { (error) in
            if error == nil {
                self.initJGProgressHUD(withText: "Reset password email was sent!", typeOfIndicator: JGProgressHUDSuccessIndicatorView(), delay: 2.0)
            } else {
                print("There was an error reseting the password")
                self.initJGProgressHUD(withText: "\(error?.localizedDescription)", typeOfIndicator: JGProgressHUDErrorIndicatorView(), delay: 2.0)
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
    
    //MARK: - Activity indicator
    private func showLoadingIndicator() {
        if activityIndicator != nil {
            self.view.addSubview(activityIndicator!)
            activityIndicator!.startAnimating()
        }
    }
    
    private func hideLoadingIndicator() {
        if activityIndicator != nil {
            activityIndicator!.removeFromSuperview()
            activityIndicator!.stopAnimating()
        }
    }


}
