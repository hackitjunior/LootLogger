//
//  ItemsViewController.swift
//  LootLogger
//
//  Created by Alberto Silva on 28/05/21.
//

import UIKit

class ItemsViewController: UITableViewController {
    
    var itemStore: ItemStore!
    var imageStore: ImageStore!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        navigationItem.leftBarButtonItem = editButtonItem
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // tableView.rowHeight = 65
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
        //let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        let item = itemStore.allItems[indexPath.row]
        
        /*cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = "$\(item.valueInDollars)"*/
        cell.nameLabel.text = item.name
        cell.serialNumberLabel.text = item.serialNumber
        cell.valueLabel.text = "$\(item.valueInDollars)"
        
        
        if(item.valueInDollars >= 50){
            cell.valueLabel.textColor = .green
        } else {
            cell.valueLabel.textColor = .red
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = itemStore.allItems[indexPath.row]
            itemStore.removeItem(item)
            imageStore.deleteImage(forKey: item.itemKey)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        itemStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
}

extension ItemsViewController {
    @IBAction func addNewItem(_ sender: UIBarButtonItem){
        let newItem = itemStore.createItem()
        if let index = itemStore.allItems.firstIndex(of:newItem) {
            let indexPath = IndexPath(row: index, section: 0)
            // Insert this new row into the table
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
        
    }
}

extension ItemsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        switch segue.identifier {
        case "showItem":
            if let row = tableView.indexPathForSelectedRow?.row {
                let item = itemStore.allItems[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.item = item
                detailViewController.imageStore = imageStore
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
}
