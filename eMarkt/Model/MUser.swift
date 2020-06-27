//
//  MUser.swift
//  eMarkt
//
//  Created by Alex Codreanu on 27/06/2020.
//  Copyright © 2020 Alex Codreanu. All rights reserved.
//

import Foundation
import FirebaseAuth

//EXPLANATION: - this class will control login, registration, updating user and managing local user
class MUser{
    
    let objectID: String
    var email: String
    var firstName: String
    var lastName: String
    var fullName: String
    var purchasedItemIDs: [String]
    var fullAddress: String?
    var onBoard: Bool
    
    
    //MARK: - Initializers
    init(_objectID: String, _email: String, _firstName: String, _lastName: String) {
        objectID = _objectID
        email = _email
        firstName = _firstName
        lastName = _lastName
        fullName = _firstName + " " + _lastName
        fullAddress = ""
        onBoard = false
        purchasedItemIDs = []
    }
    
    init(_dictionary: NSDictionary){
        objectID = _dictionary[kOBJECT] as! String
        
        if let mail = _dictionary[kEMAIL]{
            email = mail as! String
        } else {
            email = ""
        }
        
        if let fname = _dictionary[kFIRSTNAME] {
            firstName = fname as! String
        } else {
            firstName = ""
        }
        if let lname = _dictionary[kLASTNAME] {
            lastName = lname as! String
        } else {
            lastName = ""
        }
        
        fullName = firstName + " " + lastName
        
        if let faddress = _dictionary[kFULLADDRESS] {
            fullAddress = faddress as! String
        } else {
            fullAddress = ""
        }
        
        if let onB = _dictionary[kONBOARD] {
            onBoard = onB as! Bool
        } else {
            onBoard = false
        }
        
        if let purchaseIds = _dictionary[kPURCHASEDITEMIDS] {
            purchasedItemIDs = purchaseIds as! [String]
        } else {
            purchasedItemIDs = []
        }
    }
    
    //MARK: - Return current user
    class func currentID() -> String{
        return Auth.auth().currentUser!.uid
    }
    
    class func currentUser() -> MUser?{
        if Auth.auth().currentUser != nil {
            if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER){
                return MUser.init(_dictionary: dictionary as! NSDictionary)
            }
        }
        return nil;
    }
    
    //MARK: - Login function
    
    class func loginUserWith(email: String, password: String, completion: @escaping (_ error: Error?, _ isEmailVerified: Bool) -> Void){
        
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            
            if error == nil{
                if authDataResult!.user.isEmailVerified {
                    downloadUserFromFirebase(userID: authDataResult!.user.uid, email: email)
                    completion(error, true)
                } else {
                    print("Email is not verified!")
                    completion(nil, false)
                }
            } else {
                completion(error, false)
                print("There was an error!")
            }
        }
    }
    
    //MARK: - Register user
    
    class func registerUser(email: String, password: String, completion: @escaping (_ error: Error?) -> Void){
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            
            completion(error)
            
            if error == nil {
                //EXPLANATION: - sending email verification
                authDataResult!.user.sendEmailVerification { (emailError) in
                    print("auth email verification error: ", emailError?.localizedDescription)
                }
            }
        }
    }
    
    //MARK: - Resend link methods
    
    //EXPLANATION: - Reset password
    class func resetPasswordFor(email: String, completion: @escaping (_ error: Error?) -> Void){
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            completion(error)
        }
    }
    
    //EXPLANATION: - Resend verification email
    class func resendVerificationEmail(email: String, completion: @escaping (_ error: Error?) -> Void){
        //EXPLANATION: - verification for a current user if it is still logged in
        Auth.auth().currentUser?.reload(completion: { (error) in
            
            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                print("Resend email error: \(error?.localizedDescription)")
                completion(error)
            })
        })
    }
    
    //MARK: - Logout user
    class func logoutCurrentUser(completion: @escaping (_ error: Error?) -> Void){
        do{
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: kCURRENTUSER)
            UserDefaults.standard.synchronize()
            completion(nil)
        } catch let error as NSError{
            print("Error signing out!")
            completion(error)
        }
    }

}
//MARK: - Download user from Firebase
func downloadUserFromFirebase(userID: String, email: String){
    FirebaseReference(.User).document(userID).getDocument { (snapshot, error) in
        guard let snapshot = snapshot else {
            return
        }
        if snapshot.exists {
            saveUserLocally(mUserDictionary: snapshot.data()! as NSDictionary)
        } else {
            //EXPLANATION: - there is no user, save new user to firestore
            let user = MUser(_objectID: userID, _email: email, _firstName: "", _lastName: "")
            saveUserLocally(mUserDictionary: userDictionaryFrom(user: user))
            saveUserToFirestore(mUser: user)
        }
    }
}


//MARK: - Save user to Firebase

func saveUserToFirestore(mUser: MUser){
    
    FirebaseReference(.User).document(mUser.objectID).setData(userDictionaryFrom(user: mUser) as! [String : Any]) { (error) in
        if error != nil {
            print("Error saving user: ", error!.localizedDescription)
        }
    }
}

func saveUserLocally(mUserDictionary: NSDictionary){
    UserDefaults.standard.set(mUserDictionary, forKey: "currentUser")
    UserDefaults.standard.synchronize()
}

//MARK: - Update user and save to Firebase
func updateCurrentUserInFirebase(withValues: [String : Any], completion: @escaping (_ error: Error?) -> Void){
    
    if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER) {
        
        let userObject = (dictionary as! NSDictionary).mutableCopy() as! NSMutableDictionary
        //EXPLANATION: - Updating userobject
        userObject.setValuesForKeys(withValues)
        FirebaseReference(.User).document(MUser.currentID()).updateData(withValues) { (error) in
            completion(error)
            
            if error == nil {
                //EXPLANATION: - Updating local user only if the Firebase object was updated successfully
                saveUserLocally(mUserDictionary: userObject)
            }
        }
    }
}


//MARK: - Helper function

func userDictionaryFrom(user: MUser) -> NSDictionary{
    return NSDictionary(objects: [user.objectID, user.email, user.firstName, user.lastName, user.fullName, user.fullAddress ?? "", user.onBoard, user.purchasedItemIDs], forKeys: [ kOBJECT as NSCopying, kEMAIL as NSCopying, kFIRSTNAME as NSCopying, kLASTNAME as NSCopying, kFULLNAME as NSCopying, kFULLADDRESS as NSCopying, kONBOARD as NSCopying, kPURCHASEDITEMIDS as NSCopying])
}

