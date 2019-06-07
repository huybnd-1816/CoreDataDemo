//
//  ViewController.swift
//  CoreData
//
//  Created by nguyen.duc.huyb on 6/7/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    fileprivate var coreDataManager: CoreDataManager!
    fileprivate var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        users = coreDataManager.fetch(User.self)
        tableView.reloadData()
    }
    
    private func config() {
        coreDataManager = CoreDataManager.shared
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.rowHeight = 64
    }
    
    @IBAction private func handleAddButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "New User",
                                      message: "Create a new user and pet",
                                      preferredStyle: .alert)
        
        alert.addTextField { (textFieldName) in
            textFieldName.placeholder = "User's name"
        }
        
        alert.addTextField { (textFieldAge) in
            textFieldAge.placeholder = "Age"
        }
        
        alert.addTextField { (textFieldPetName) in
            textFieldPetName.placeholder = "Pet's name"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            guard let textFieldName = alert.textFields?.first,
                let nameToSave = textFieldName.text,
                let textFieldAge = alert.textFields?[1],
                let ageToSave = textFieldAge.text,
                let textFieldPetName = alert.textFields?[2],
                let petNameToSave = textFieldPetName.text else {
                    return
            }
            
            guard let pet = self.coreDataManager.insertPet(name: petNameToSave),
                let user = self.coreDataManager.insertUser(name: nameToSave, age: Int(ageToSave)!, pet: pet) else { return }
            
            self.users.append(user)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        present(alert, animated: true)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let user = users[indexPath.row]
        cell.configCell(user: user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
        vc.user = users[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            guard indexPath.row < users.count,
                let userName = users[indexPath.row].name else { return }
            
            if coreDataManager.delete(name: userName) {
                users.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            return
        }
    }
}
