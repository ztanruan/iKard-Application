//
//  FirebaseManager.swift
//  DreamClear
//
//  Created by Bhavik Barot on 25/03/20.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

/// It is used for sending back response to the controller from the manager class
/// - Author: Bhavik Barot
public enum FirebaseResponse {
    case success(data: Any?)
    case error(error: Error?)
}

/// This class is made for removing dependancy of Firebase's ListenerRegistration class with other classes.
/// - Author: Bhavik Barot
public class FirebaseManagerListenerRegistration: NSObject {
    var listener: ListenerRegistration!
    
    private override init() {}
    public init(listener: ListenerRegistration) {
        self.listener = listener
    }
}

/// FirebaseManager class is used to give the generic functions to communicate between app to the Firestore and Authentication.
/// - Author: Bhavik Barot
class FirebaseManager: NSObject {
    public static let shared = FirebaseManager()
    
    private var db: Firestore!
    private var storage: StorageReference!
    
    private override init() {}
    
}
//MARK:- Firebase Auth Methods
extension FirebaseManager {
    func getCurrentUser() -> User? {
        return Auth.auth().currentUser
    }
    
    /// This method will use to register new user with the app by using Firebase Auth and it will generate the new entry for the given user.
    /// - Author: Bhavik Barot
    /// - Parameters:
    ///   - email: User's Email
    ///   - password: User's Password
    ///   - completion: To send back response to the controller from the Firestore.
    func signupAuth(with email: String, and password: String, completion: @escaping ((FirebaseResponse) -> ())) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let err = error {
                completion(.error(error: err))
            }
            else {
                if let user = self.getCurrentUser() {
                    completion(.success(data: user.uid))
                }
                else {
                    completion(.success(data: result!.user.uid))
                }
            }
        }
    }
    
    /// This method will provide the signin functionality by using Firebase Authentication.
    /// - Author: Bhavik Barot
    /// - Parameters:
    ///   - email: User's Email
    ///   - password: User's Password
    ///   - completion: To send back response to the controller from the Firestore.
    func signinAuth(with email: String, and password: String, completion: @escaping ((FirebaseResponse) -> ())) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let err = error {
                completion(.error(error: err))
            }
            else {
                if let user = self.getCurrentUser() {
                    completion(.success(data: user.uid))
                }
                else {
                    completion(.success(data: result!.user.uid))
                }
            }
        }
    }
    
    /// This method will provide the signout functionality by using Firebase Authentication.
    /// - Author: Bhavik Barot
    /// - Throws: **error** Optionally; if an error occurs, upon return contains an NSError object that describes the problem; is nil otherwise.
    func signoutAuth() throws {
        try! Auth.auth().signOut()
    }
    
    /// This method is used to send reset password link to the registered email.
    /// - Author: Bhavik Barot
    /// - Parameters:
    ///   - email: User's email
    ///   - completion: To send back response to the controller from the Firestore.
    func resetPasswordAuth(for email: String, completion: @escaping ((FirebaseResponse) -> ())) {
        Auth.auth().sendPasswordReset(withEmail: email) { (err) in
            if let err = err {
                completion(.error(error: err))
            }
            else {
                completion(.success(data: nil))
            }
        }
    }
    
    /// Fetches the list of all sign-in methods previously used for the provided email address.
    /// - Author: Bhavik Barot
    /// - Parameters:
    ///   - email: User's email
    ///   - completion: To send back response to the controller from the Firestore.
    func fetchProviders(for email: String, completion: @escaping ((FirebaseResponse) -> ())) {
        Auth.auth().fetchSignInMethods(forEmail: email) { (providers, error) in
            if let error = error {
                completion(.error(error: error))
            } else {
                completion(.success(data: providers))
            }
        }
    }
    
    
    
    func GetUserNameEmailFromFirebaseStorage(_ strUID: String, completion:@escaping ()->Void) {
        let ref = Database.database().reference(withPath: "users").child(strUID)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if !snapshot.exists() {
                completion()
                return
            }
            if let dicData = snapshot.value as? [String: Any] {
                UserDefaults.appSetObject(NSKeyedArchiver.archivedData(withRootObject: dicData), forKey: AppMessage.userData)
                completion()
            }
        })
    }
    
    func UpdateMobileNumberInFromFirebaseStorage(_ strMobile: String, completion:@escaping ()->Void)  {
        let ref = Database.database().reference(withPath: "users").child(GetUserID())
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if !snapshot.exists() { return }
            if let dicData = snapshot.value as? [String: Any] {
                var userData = dicData
                userData["phone"] = strMobile
                let ref = Database.database().reference()
                ref.child("users").child(GetUserID()).updateChildValues(userData)
                self.GetUserNameEmailFromFirebaseStorage(GetUserID()) {
                    print("Data get from Database")
                    completion()
                }
            }
        })
    }
    
    func MobileNumberAlreadyExistsFirebaseStorage(_ strMobile: String, completion:@escaping (Bool)->Void)  {
        let ref = Database.database().reference(withPath: "users")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if !snapshot.exists() {
                completion(false)
            }
            else {
                var is_mobileexist: Bool = false
                for dataaa in snapshot.children.allObjects as! [DataSnapshot] {
                    guard let restDict = dataaa.value as? [String: Any] else { continue }
                    let mobile = restDict["phone"] as? String ?? ""
                    if mobile == strMobile {
                        is_mobileexist = true
                    }
                }
                completion(is_mobileexist)
            }
        })
    }
    
    
    func UpdateProfilePictureInFromFirebaseStorage(_ strProfile: String, completion:@escaping ()->Void)  {
        let ref = Database.database().reference(withPath: "users").child(GetUserID())
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if !snapshot.exists() { return }
            if let dicData = snapshot.value as? [String: Any] {
                var userData = dicData
                userData["profile"] = strProfile
                let ref = Database.database().reference()
                ref.child("users").child(GetUserID()).updateChildValues(userData)
                self.GetUserNameEmailFromFirebaseStorage(GetUserID()) {
                    print("Data get from Database")
                    completion()
                }
            }
        })
    }
    
    
    func GetSocialUserStoredInFirebaseStorage(_ strUID: String, completion:@escaping (Bool?)->Void) {
        let ref = Database.database().reference(withPath: "users").child(strUID)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if !snapshot.exists() {
                completion(false)
            }
            else if let dicData = snapshot.value as? [String: Any] {
                completion(true)
                UserDefaults.appSetObject(NSKeyedArchiver.archivedData(withRootObject: dicData), forKey: AppMessage.userData)
            }
            else {
                completion(false)
            }
        })
    }
    
    func GetMyBusinessCardsListFromFirebaseStorage(completion:@escaping ([[String: Any]]?)->Void) {
        var arr_data = [[String: Any]]()
        let ref = Database.database().reference(withPath: "business_detail").child(GetUserID())
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if !snapshot.exists() {
                completion(arr_data)
            }
            else {
                for dataaa in snapshot.children.allObjects as! [DataSnapshot] {
                    guard let restDict = dataaa.value as? [String: Any] else { continue }
                    var dic = restDict
                    dic["id"] = dataaa.key
                    arr_data.append(dic)
                }
                completion(arr_data)
            }
        })
    }
    
    func GetAllBusinessCardsListFromFirebaseStorage(completion:@escaping ([[String: Any]]?)->Void) {
        var arr_data = [[String: Any]]()
        let ref = Database.database().reference(withPath: "business_detail")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if !snapshot.exists() {
                completion(arr_data)
            }
            else {
                for dataaa in snapshot.children.allObjects as! [DataSnapshot] {
                    guard let restDict = dataaa.value as? [String: Any] else { continue }
                    arr_data.append(restDict)
                }
                completion(arr_data)
            }
        })
    }
    
    func GetScannedBusinessCardsListFromFirebaseStorage(completion:@escaping ([[String: Any]]?)->Void) {
        var arr_data = [[String: Any]]()
        let ref = Database.database().reference(withPath: "scanned_business_detail").child(GetUserID())
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if !snapshot.exists() {
                completion(arr_data)
            }
            else {
                for dataaa in snapshot.children.allObjects as! [DataSnapshot] {
                    guard let restDict = dataaa.value as? [String: Any] else { continue }
                    arr_data.append(restDict)
                }
                completion(arr_data)
            }
        })
    }
    
    func GetParticularBusinessCardsFromFirebaseStorage(scanned_qr_code: String, completion:@escaping (Bool)->Void) {
        var is_added_businesscard_detail = false
        let ref = Database.database().reference(withPath: "business_detail")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if !snapshot.exists() {
                completion(is_added_businesscard_detail)
            }
            else {
                var is_addedCard = false
                var selected_dic = [String: Any]()
                for dataaa in snapshot.children.allObjects as! [DataSnapshot] {
                    for dic_data in dataaa.children.allObjects as! [DataSnapshot] {
                        guard let restDict = dic_data.value as? [String: Any] else { continue }
                        let qrCode = restDict["qr_code"] as? String ?? ""
                        let user_id = restDict["user_id"] as? String ?? ""
                        if qrCode == scanned_qr_code {
                            if user_id == GetUserID() {
                                appDelegate.window?.rootViewController?.view.makeToast("it's your created business card")
                            }
                            else {
                                is_addedCard = true
                                selected_dic = restDict
                            }
                        }
                    }
                }
                
                
                if is_addedCard {
                    self.is_Added_ScannedBusinessCardsInFirebaseStorage(qr_code: scanned_qr_code, completion: { (is_add) in
                        if is_add {
                            let scan_ref = Database.database().reference()
                            is_added_businesscard_detail = true
                            scan_ref.child("scanned_business_detail").child(GetUserID()).childByAutoId().updateChildValues(selected_dic)
                            completion(is_added_businesscard_detail)
                        }
                        else {
                            completion(is_added_businesscard_detail)
                        }
                    })
                }
                else {
                    completion(is_added_businesscard_detail)
                }

            }
        })
    }
    
    
    func is_Added_ScannedBusinessCardsInFirebaseStorage(qr_code: String, completion:@escaping (Bool)->Void) {
        var is_addedScannedCard = false
        let ref = Database.database().reference(withPath: "scanned_business_detail").child(GetUserID())
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if !snapshot.exists() {
                completion(true)
            }
            else {
                var is_added = false
                for dataaa in snapshot.children.allObjects as! [DataSnapshot] {
                    guard let restDict = dataaa.value as? [String: Any] else { continue }
                    let str_qr_code = restDict["qr_code"] as? String ?? ""
                    if str_qr_code == qr_code {
                        is_added = true
                        appDelegate.window?.rootViewController?.view.makeToast("It's already added")
                    }
                }
                
                if is_added == false {
                    is_addedScannedCard = true
                }
                completion(is_addedScannedCard)
            }
        })
    }
    
    
    
    
           
                    
    
    
    
}
//MARK:- Firestore Methods
extension FirebaseManager {
    /// Configure the app with the Firebase server.
    /// - Author: Bhavik Barot
    func configureApp() {
        FirebaseApp.configure()
        self.db = Firestore.firestore()
        self.storage = Storage.storage().reference()
    }
    
    /// This method is used to add new document/entry to the server
    /// - Author: Bhavik Barot
    /// - Parameters:
    ///   - collection: It is the collection enum for getting the collection of the database
    ///   - data: Data is the key pair value to store in the newly created document at the mentioned collection on the server.
    ///   - completion: To send back response to the controller from the Firestore.
//    func addNewDocument(for collection: FirebaseConstants.Collections, with data: [String: Any], completion: @escaping ((FirebaseResponse) -> ())) {
//        // Add a new document with a generated ID
//        var ref: DocumentReference? = nil
//        ref = self.db.collection(collection.rawValue).addDocument(data: data) { err in
//            if let err = err {
//                completion(.error(error: err))
//            } else {
//                if let docId = ref?.documentID {
//                    completion(.success(data: docId))
//                }
//                else {
//                    completion(.error(error: nil))
//                }
//            }
//        }
//    }
    
    /// This method is used to add data in particular document to the server. You can use it to create new document for particular document id or you can set the data into the already generated document, by it's id.
    /// - Author: Bhavik Barot
    /// - Parameters:
    ///   - data: Data is the key pair value to store in the newly created document at the mentioned collection on the server.
    ///   - document: It is the document id for getting the document of the database
    ///   - collection: It is the collection enum for getting the collection of the database
    ///   - completion: To send back response to the controller from the Firestore.
//    func add(data: [String: Any], in document: String, for collection: FirebaseConstants.Collections, completion: @escaping ((FirebaseResponse) -> ())) {
//        self.db.collection(collection.rawValue).document(document).setData(data) { err in
//            if let err = err {
//                completion(.error(error: err))
//            } else {
//                completion(.success(data: true))
//            }
//        }
//    }
    
    /// This method is used to update data in particular document to the server.
    /// - Author: Bhavik Barot
    /// - Parameters:
    ///   - data: Data is the key pair value to update in the created document at the mentioned collection on the server.
    ///   - document: It is the document id for getting the document of the database
    ///   - collection: It is the collection enum for getting the collection of the database
    ///   - completion: To send back response to the controller from the Firestore.
    /*func update(data: [String: Any], in document: String, for collection: FirebaseConstants.Collections, completion: @escaping ((FirebaseResponse) -> ())) {
        self.db.collection(collection.rawValue).document(document).updateData(data) { (err) in
            if let err = err {
                completion(.error(error: err))
            } else {
                completion(.success(data: true))
            }
        }
    }
    */
    
    /// This method is used to delete data for particular key in document to the server.
    /// - Author: Bhavik Barot
    /// - Parameters:
    ///   - value: Value is the key pair value to delete in the document at the mentioned collection on the server.
    ///   - document: It is the document id for getting the document of the database
    ///   - collection: It is the collection enum for getting the collection of the database
    ///   - completion: To send back response to the controller from the Firestore.
//    func deleteValue(keys: [String], in document: String, for collection: FirebaseConstants.Collections, completion: @escaping ((FirebaseResponse) -> ())) {
//        var data = [String: Any]()
//        for key in keys {
//            data[key] = FieldValue.delete()
//        }
//        self.db.collection(collection.rawValue).document(document).updateData(data) { (err) in
//            if let err = err {
//                completion(.error(error: err))
//            } else {
//                completion(.success(data: true))
//            }
//        }
//    }
    
    /// This method is called to get all the documents from the desired colleciton.
    /// - Author: Bhavik Barot
    /// - Parameters:
    ///   - collection: It is the collection enum for getting the collection of the database
    ///   - completion: To send back response to the controller from the Firestore.
//    func getAllData(for collection: FirebaseConstants.Collections, completion: @escaping ((FirebaseResponse) -> ())) {
//        self.db.collection(collection.rawValue).getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                completion(.error(error: err))
//            } else {
//                completion(.success(data: querySnapshot?.documents))
//            }
//        }
//    }
    
    /// This method is called to get the particular documents from the desired colleciton.
    /// - Author: Bhavik Barot
    /// - Parameters:
    ///   - collection: It is the collection enum for getting the collection of the database
    ///   - id: Document ID
    ///   - completion: To send back response to the controller from the Firestore.
//    func getDocument(for collection: FirebaseConstants.Collections, of id: String, completion: @escaping ((FirebaseResponse) -> ())) {
//        self.db.collection(collection.rawValue).document(id).getDocument  { (documentSnapshot, err) in
//            if let err = err {
//                completion(.error(error: err))
//            } else {
//                if let document = documentSnapshot {
//                    completion(.success(data: document.data()))
//                }
//                else {
//                    completion(.error(error: err))
//                }
//            }
//        }
//    }
    
    /// It will set continuesly Listener for the particular document and this will give callback for every modification.
    /// - Author: Bhavik Barot
    /// - Parameters:
    ///   - collection: It is the collection enum for getting the collection of the database
    ///   - id: Document ID
    ///   - completion: To send back response to the controller from the Firestore.
//    func listenFor(for collection: FirebaseConstants.Collections, of id: String, completion: @escaping ((FirebaseResponse, FirebaseManagerListenerRegistration) -> ())) {
//        var listenFor: ListenerRegistration!
//        listenFor = self.db.collection(collection.rawValue).document(id).addSnapshotListener { (documentSnapshot, err) in
//            let lstnr = FirebaseManagerListenerRegistration(listener: listenFor)
//            if let err = err {
//                completion(.error(error: err), lstnr)
//            } else {
//                completion(.success(data: documentSnapshot?.data()), lstnr)
//            }
//        }
//    }
    
    /// It will called for removing the given listener to maintain retain cycle.
    /// - Author: Bhavik Barot
    /// - Parameter listener: Listener object to remove.
    func remove(listener: FirebaseManagerListenerRegistration) {
        listener.listener.remove()
    }
}
//MARK:- Firebase Storage Methods
extension FirebaseManager {
    //MARK:- Download Functions
    /// It will called for downloading any file from `Firebase Storage`.
    /// - Author: Bhavik Barot
    /// - Parameters:
    ///   - url: Storage URL for file to download.
    ///   - completion: To send back response to the controller from the Firestore.
    func downloadFile(from url: String, progress: @escaping ((Progress?) -> ()), completion: @escaping ((FirebaseResponse) -> ())) {
        let ref = self.getChilds(from: url)
        let uploadTask = ref.getData(maxSize: (10 * 1024 * 1024)) { (data, error) in
            if let error = error {
                completion(.error(error: error))
            }
            else {
                completion(.success(data: data))
            }
        }
        _ = uploadTask.observe(.progress) { snapshot in
            progress(snapshot.progress)
        }
    }
    
    //MARK:- Upload Functions
    /// It will called for upload any file from `Firebase Storage`.
    /// - Author: Bhavik Barot
    /// - Parameters:
    ///   - data: file content which will be stored in file.
    ///   - url: Storage URL for file at which the file to be uploaded.
    ///   - completion: To send back response to the controller from the Firestore.
    func uploadFile(with data: Data, to url: String, progress: @escaping ((Progress?) -> ()), completion: @escaping ((FirebaseResponse) -> ())) {
        let ref = self.getChilds(from: url)
        let uploadTask = ref.putData(data, metadata: nil) { (metaData, error) in
            if let error = error {
                completion(.error(error: error))
            }
            else {
                completion(.success(data: metaData?.path))
            }
        }
        
        _ = uploadTask.observe(.progress) { snapshot in
            progress(snapshot.progress)
        }
    }
    
    //MARK:- Utility Function
    /// It will give the last `child` object of `StorageReference`.
    /// - Author: Bhavik Barot
    /// - Parameter path: Path or URL for the storage folder structure.
    /// - Returns: `StorageReference` instance.
    private func getChilds(from path: String) -> StorageReference {
        let childs = path.components(separatedBy: "/")
        var child: StorageReference = self.storage ?? Storage.storage().reference()
        for pathItem in childs {
            if pathItem != "" && pathItem != " " {
                child = child.child(pathItem.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
        return child
    }
}
