//
//  LoginViewController.swift
//  Chatty
//
//  Created by Neha Patil on 12/31/20.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    private let spinner = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
  

    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextField.text,
            let password = passwordTextField.text {
            spinner.show(in: view)
            FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] authResult, error in
                guard let strongSelf = self else {
                    return
                }

                DispatchQueue.main.async {
                    strongSelf.spinner.dismiss()
                }

                guard let result = authResult, error == nil else {
                    print("Failed to log in user with email: \(email)")
                    return
                }

                let user = result.user

                let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
    
                DatabaseManager.shared.getDataFor(path: safeEmail, completion: { result in
                    switch result {
                    case .success(let data):
                        guard let userData = data as? [String: Any],
                            let firstName = userData["first_name"] as? String,
                            let lastName = userData["last_name"] as? String else {
                                return
                        }
                        UserDefaults.standard.set("\(firstName) \(lastName)", forKey: "name")

                    case .failure(let error):
                        print("Failed to read data with error \(error)")
                    }
                })

                UserDefaults.standard.set(email, forKey: "email")

                print("Logged In User: \(user)")
                self?.performSegue(withIdentifier: "LoginToHome", sender: self)
            })
           
    }

}
}
