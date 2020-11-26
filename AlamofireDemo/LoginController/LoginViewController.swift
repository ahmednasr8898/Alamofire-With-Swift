//
//  ViewController.swift
//  AlamofireDemo
//
//  Created by Ahmed Nasr on 11/25/20.
//
import UIKit
import Alamofire

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextFields: UITextField!
    @IBOutlet weak var passwordTextFields: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
    }
    
    @IBAction func loginOnClick(_ sender: Any) {
        guard let email = emailTextFields.text, !email.isEmpty, let password = passwordTextFields.text, !password.isEmpty else { return }
        
        let url = "https://elzohrytech.com/alamofire_demo/api/v1/login"
        let parameters = ["email": email, "password": password]
        
        AF.request(url,method: .post,parameters: parameters,encoding: URLEncoding.default).responseJSON { (response) in
            switch response.result{
            case .failure(let error):
                print("error when connect with login server:\(error.localizedDescription)")
            case .success(_):
                print("connect with login server")
                guard let data = response.data else { return }
                
                do{
                    let json = try JSONDecoder().decode(LoginModel.self, from: data)
                    if let api_token = json.user?.apiToken{
                        print("Login suucess: \(api_token)")
                        UserDefaults.standard.setValue(api_token, forKey: "api_token")
                        self.goToTasksPage()
                       // self.goto(viewControllerName: "TasksViewController")
                    }
                }catch{
                    print("error when login \(error.localizedDescription)")
                }
            }
        }
    }
    
    func goToTasksPage(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TasksViewController")
        navigationController?.pushViewController(storyboard, animated: true)
       // present(storyboard, animated: true, completion: nil)
    }
}
//Login by ApiService Generic
extension LoginViewController{
    func login(){
        guard let email = emailTextFields.text, !email.isEmpty, let password = passwordTextFields.text, !password.isEmpty else { return }
        
        let url = "https://elzohrytech.com/alamofire_demo/api/v1/login"
        let parameters = ["email": email, "password": password]
     
        APIServices.connectWithServer(url: url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil) { (loginModel: LoginModel?, error: Error?) in
         
            if let error = error{
                print("error is \(error.localizedDescription)")
            }else if let loginModel = loginModel{
                guard let apitoken = loginModel.user?.apiToken else { return }
                print("Login suucess: \(apitoken)")
                UserDefaults.standard.setValue(apitoken, forKey: "api_token")
            }
        }
    }
}

