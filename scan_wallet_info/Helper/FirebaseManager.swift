import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

public enum FirebaseResponse {
    case success(data: Any?)
    case error(error: Error?)
}

public class FirebaseManagerListenerRegistration: NSObject {
    var listener: ListenerRegistration!
    
    private override init() {}
    public init(listener: ListenerRegistration) {
        self.listener = listener
    }
}

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
    
    func signoutAuth() throws {
        try! Auth.auth().signOut()
    }
    
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


extension FirebaseManager {
    func configureApp() {
        FirebaseApp.configure()
        self.db = Firestore.firestore()
        self.storage = Storage.storage().reference()
    }

    func remove(listener: FirebaseManagerListenerRegistration) {
        listener.listener.remove()
    }
}


extension FirebaseManager {

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
