//
//  ChangeDateViewController.swift
//  LootLogger
//
//  Created by Alberto Silva on 03/06/21.
//

import UIKit

class ChangeDateViewController: UIViewController {
    var item: Item!
    
    @IBOutlet var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker.setDate(item.dateCreated, animated: true)
        datePicker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
    }
    
    @objc func datePickerChanged(_ sender: UIDatePicker){
        item.updateDate(with: sender.date)
    }
}
