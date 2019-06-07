//
//  TableViewCell.swift
//  CoreDataDemo
//
//  Created by nguyen.duc.huyb on 6/10/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import UIKit

final class TableViewCell: UITableViewCell {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    var lstPet: [Pet] = []
    
    func configCell(user: User) {
        userNameLabel.text = user.name
        ageLabel.text = String(user.age)
        guard let pets = user.pets else { return }
        for item in pets {
            guard let pet = item as? Pet else { return }
            lstPet.append(pet)
        }
        petNameLabel.text = lstPet[0].name
    }
}
