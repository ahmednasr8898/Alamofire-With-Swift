//
//  TasksViewController.swift
//  AlamofireDemo
//
//  Created by Ahmed Nasr on 11/26/20.
//
import UIKit
import Alamofire
class TasksViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var arrOfDataTasks = [Data]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        tableView.dataSource = self
        tableView.delegate = self
        checkCurrentUser()
        getAllTasks()
    }
    func checkCurrentUser(){
        guard  UserDefaults.standard.object(forKey: "api_token") == nil else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
        navigationController?.pushViewController(storyboard, animated: true)
    }
    @IBAction func addTasksOnClick(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Tasks", message: "", preferredStyle: .alert)
        alert.addTextField { (txt) in txt.placeholder = "write your task"}
        let addButton = UIAlertAction(title: "add", style: .default) { (_) in
         
            self.addNewTask(taskMessege: alert.textFields?[0].text ?? "")
        }
        alert.addAction(addButton)
        self.present(alert, animated: true, completion: nil)
    }
}
extension TasksViewController: UITableViewDataSource{
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfDataTasks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = arrOfDataTasks[indexPath.row].task
        return cell
    }
}
extension TasksViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "delete") { (_, _, _) in
            //delete item
            //select item for delete
            let taskSelected = self.arrOfDataTasks[indexPath.row]
            guard let task_id = taskSelected.id else {return}
            self.deleteTask(task_id: task_id) { (deleteTaskModel: DeleteTaskModel?, error: Error?) in
                if let error = error{
                    print("error when conncetion with server delete task: \(error.localizedDescription)")
                }else if let deleteTask = deleteTaskModel{
                    if deleteTask.status == 1 {
                        self.arrOfDataTasks.remove(at: indexPath.row)
                        self.tableView.reloadData()
                        print(deleteTask.msg ?? "")
                    }else{
                        print("delete tasks is falid \(String(describing: error?.localizedDescription))")
                    }
                }
            }
        }
        let edit = UIContextualAction(style: .normal, title: "edit") { (_, _, _) in
            let alert = UIAlertController(title: "Edit Task", message: "", preferredStyle: .alert)
            alert.addTextField()
            //select item to edit
            let taskSelect = self.arrOfDataTasks[indexPath.row]
            alert.textFields?[0].text = taskSelect.task
            let editButton = UIAlertAction(title: "edit", style: .default) { (_) in
                //edit task
                guard let newTask = alert.textFields?[0].text, let task_id = taskSelect.id else{return}
                self.editTask(newTask: newTask, task_id: task_id) { (editTaskModel: EditTaskModel?, error: Error?) in
                    if let error = error{
                        print("error in editTask: \(error.localizedDescription)")
                    }else if let editTask = editTaskModel{
                        if editTask.status == 1 {
                            self.arrOfDataTasks.remove(at: indexPath.row)
                            self.arrOfDataTasks.insert(editTask.task!, at: indexPath.row)
                            self.tableView.reloadData()
                            print("edit task is success: \(editTask.msg ?? "")")
                        }else {
                            print("edit task is faild: \(editTask.msg ?? "")")
                        }
                    }
                }
            }
            alert.addAction(editButton)
            self.present(alert, animated: true, completion: nil)
        }
        return UISwipeActionsConfiguration(actions: [delete,edit])
    }
}
//Add New Task
extension TasksViewController{
    func addNewTask(taskMessege: String){
        guard let api_token = UserDefaults.standard.object(forKey: "api_token")  else { return }
        
        let url = "https://elzohrytech.com/alamofire_demo/api/v1/task/create"
        let parameters = ["api_token": api_token, "task": taskMessege]
   
        APIServices.connectWithServer(url: url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil) { (addTaskModel: AddTaskModel?, error: Error?) in
         
            if let error = error{
                print("error in addNewTask: \(error.localizedDescription)")
            }else if let addTask = addTaskModel{
                guard addTask.status == 1 else { return }
                self.arrOfDataTasks.append(addTask.task!)
                self.tableView.reloadData()
                print("Add Task Success: \(addTask.msg ?? "")")
            }
        }
    }
}
//Get All Tasks
extension TasksViewController{
    func getAllTasks(){
        guard let api_token = UserDefaults.standard.object(forKey: "api_token")  else { return }
        
        let url = "https://elzohrytech.com/alamofire_demo/api/v1/tasks"
        let parameter = ["api_token": api_token]
        
        APIServices.connectWithServer(url: url, method: .get, parameters: parameter, encoding: URLEncoding.default, headers: nil) { (getAllTasksModel: GetAllTasksModel?, error: Error?) in
         
            if let error = error{
                print("error in GetAllTasks: \(error.localizedDescription)")
            }else if let getTasks = getAllTasksModel{
                self.arrOfDataTasks.append(contentsOf: getTasks.data!)
                self.tableView.reloadData()
                print("get All data is success")
            }
        }
    }
}
//Delete item
extension TasksViewController{
    //using AF directly
    func deleteTask(task_id: Int, complation: @escaping (DeleteTaskModel?,Error?)-> Void){
        guard let api_token = UserDefaults.standard.object(forKey: "api_token")  else { return }

        let url = "https://elzohrytech.com/alamofire_demo/api/v1/task/delete"
        let parameters = ["api_token": api_token, "task_id": task_id]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON { (response) in
            switch response.result{
            case .failure(let error):
                complation(nil,error)
            case .success(_):
                guard let data = response.data else { return }
                do{
                    let json = try JSONDecoder().decode(DeleteTaskModel.self, from: data)
                    complation(json, nil)
                }catch{
                    complation(nil,error)
                }
            }
        }
    }
    //using ApiService Generic
    func deleteTask1(task_id: Int, row: Int){
        guard let api_token = UserDefaults.standard.object(forKey: "api_token")  else { return }

        let url = "https://elzohrytech.com/alamofire_demo/api/v1/task/delete"
        let parameters = ["api_token": api_token, "task_id": task_id]
        
        APIServices.connectWithServer(url: url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil) { (deleteTasksModel: DeleteTaskModel? , error :Error?) in
            if let error = error{
                print("error when conncetion with server delete task: \(error.localizedDescription)")
            }else if let deleteTask = deleteTasksModel{
                if deleteTask.status == 1 {
                    self.arrOfDataTasks.remove(at: row)
                    self.tableView.reloadData()
                    print(deleteTask.msg ?? "")
                }else{
                    print("delete tasks is falid \(String(describing: error?.localizedDescription))")
                }
            }
        }
    }
}
//Edit task
extension TasksViewController{
    func editTask(newTask: String, task_id: Int, compation: @escaping (EditTaskModel?, Error?)->Void){
        guard let api_token = UserDefaults.standard.object(forKey: "api_token")  else { return }
        
        let url = "https://elzohrytech.com/alamofire_demo/api/v1/task/edit"
        let parameters = ["api_token": api_token,"task": newTask ,"task_id": task_id]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON { (response) in
            switch response.result{
            case .failure(let error):
                compation(nil,error)
            case .success(_):
                guard let data = response.data else { return }
                do{
                    let json = try JSONDecoder().decode(EditTaskModel.self, from: data)
                    compation(json,nil)
                }catch{
                    compation(nil,error)
                }
            }
        }
    }
}
