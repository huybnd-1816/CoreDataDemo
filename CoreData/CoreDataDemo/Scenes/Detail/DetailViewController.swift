//
//  DetailViewController.swift
//  CoreDataDemo
//
//  Created by nguyen.duc.huyb on 6/10/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import UIKit

final class DetailViewController: UIViewController {
    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var ageTextField: UITextField!
    @IBOutlet private weak var petNameTextField: UITextField!
    
    private var coreDataManager: CoreDataManager!
    var user: User!
    private var pets: [Pet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    private func config() {
        coreDataManager = CoreDataManager.shared

        guard let lstPets = user.pets else { return }
        for item in lstPets {
            guard let pet = item as? Pet else { return }
            pets.append(pet)
        }
        
        userNameTextField.text = user.name
        ageTextField.text = String(user.age)
        petNameTextField.text = pets[0].name
    }
    
    @IBAction func handleUpdateButtonTapped(_ sender: Any) {
        guard let userName = userNameTextField.text,
            let age = ageTextField.text,
            let petName = petNameTextField.text else {
                return
        }
        
        guard coreDataManager.updatePet(name: petName, pet: pets[0]),
            coreDataManager.updateUser(name: userName, age: Int(age)!, pet: pets[0], user: user) else { return }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handleDeleteButtonTapped(_ sender: Any) {
        if coreDataManager.delete(user) && coreDataManager.delete(pets[0]) {
            navigationController?.popViewController(animated: true)
        }
    }
}
