//
//  FUser.swift
//  CoffeeApp
//
//  Created by Dogukan Gundogan on 27.02.2022.
//

import Foundation
import FirebaseAuth


class FUser{
    
    let id:String
    var email:String
    var firstName:String
    var lastName:String
    var fullName:String
    var phoneNumber:String
    
    var fullAddress:String?
    var onBoard:Bool
    
    init(_id:String,_email:String,_firstName:String,_lastName:String,_phoneNumber:String) {
        self.id = _id
        self.email = _email
        self.firstName = _firstName
        self.lastName = _lastName
        self.fullName = _firstName + " " + _lastName
        self.phoneNumber = _phoneNumber
        self.onBoard = false
    }
    
    init(_ dictionary:NSDictionary){
        id = dictionary[kID] as? String ?? ""
        email = dictionary[kEMAIL] as? String ?? ""
        firstName = dictionary[kFIRSTNAME] as? String ?? ""
        lastName = dictionary[kLASTNAME] as? String ?? ""
        fullName = "\(firstName) \(lastName)"
        fullAddress = dictionary[kADDRESS] as? String ?? ""
        phoneNumber = dictionary[kPHONE] as? String ?? ""
        onBoard = dictionary[kONBOARD] as? Bool ?? false
    }
    
    class func currentId()->String{
        return Auth.auth().currentUser!.uid
    }
    
    class func currentUser()->FUser?{
        if Auth.auth().currentUser != nil{
            if let dictionary = userDefaults.object(forKey: kCURRENTUSER){
                FUser.init(dictionary as! NSDictionary)
            }
        }
        return nil
    }
    
    class func resetPassword(email:String,completion: @escaping (_ error:Error?)->Void){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
    
    class func logoutCurrentUser(completion: @escaping (_ error:Error?)->Void){
        do{
            try Auth.auth().signOut()
            userDefaults.removeObject(forKey: kCURRENTUSER)
            userDefaults.synchronize()
            
            completion(nil)
        }catch let error as Error{
            completion(error)
        }
    }
    
    class func loginUserWith(email:String,password:String,completion: @escaping (_ error:Error?,_ isEmailVerified:Bool)->Void){
        Auth.auth().signIn(withEmail: email, password: password) { authData, error in
            if let error = error{
                completion(error,false)
            }else{
                if authData!.user.isEmailVerified{
                    downloadFromFirebase(userId: authData!.user.uid, email: email) { errorFromFirestore in
                        completion(errorFromFirestore,authData!.user.isEmailVerified)
                    }
                }else{
                    completion(error,false)
                }
            }
        }
    }
    
    class func registerUserWith(email:String, password:String, completion: @escaping (_ error:Error?)->Void){
        Auth.auth().createUser(withEmail: email, password: password) { authData, error in
            completion(error)
            
            if error == nil{
                authData?.user.sendEmailVerification(completion: { errorFromEmail in
                    completion(error)
                })
            }
        }
    }
}

func downloadFromFirebase(userId:String,email:String,completion: @escaping (_ error:Error?)->Void){
    FirebaseReferance(.User).document(userId).getDocument { snapshot, error in
        guard let snapshot = snapshot else {
            return
        }
        if snapshot.exists{
            saveUserLocally(userDictionary: snapshot.data()! as NSDictionary)
        }else{
            let user = FUser(_id: userId, _email: email, _firstName: "", _lastName: "", _phoneNumber: "")
            saveUserLocally(userDictionary: userDictionaryFrom(user: user) as NSDictionary)
            saveToFirebase(fUser: user)
        }
    }
}

func updateUser(withValues:[String:Any],completion: @escaping (_ error:Error?)->Void){
    if let dictionary = userDefaults.object(forKey: kCURRENTUSER){
        let userObject = (dictionary as! NSDictionary).mutableCopy() as! NSMutableDictionary
        userObject.setValuesForKeys(withValues)
        FirebaseReferance(.User).document(FUser.currentId()).updateData(withValues) { error in
            completion(error)
            if error == nil{
                saveUserLocally(userDictionary: userObject)
            }
        }
        
    }
}

func saveToFirebase(fUser:FUser){
    FirebaseReferance(.User).document(fUser.id).setData(userDictionaryFrom(user: fUser)) { error in
        if let error = error{
            print(error)
        }
    }
}

func saveUserLocally(userDictionary:NSDictionary){
    userDefaults.set(userDictionary, forKey: kCURRENTUSER)
    userDefaults.synchronize()
}

func userDictionaryFrom(user:FUser)->[String:Any]{
    return NSDictionary(objects: [user.id,
                                  user.email,
                                  user.firstName,
                                  user.lastName,
                                  user.fullName ,
                                  user.onBoard,
                                  user.phoneNumber
        ],forKeys:[kID as NSCopying,
                   kEMAIL as NSCopying,
                   kFIRSTNAME as NSCopying,
                   kLASTNAME as NSCopying,
                   kFULLNAME as NSCopying,
                   kONBOARD as NSCopying,
                   kPHONE as NSCopying
                  ]) as! [String:Any]
}
