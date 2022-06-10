//
//  TDLHomeController.swift
//  TodoList
//
//  Created by 孙磊 on 2022/6/9.
//

import UIKit

class TDLHomeController: TDLBaseTVController {
    
    var itemArray : [String] = []
    
    let defaults = UserDefaults.standard
    let cellID = "HomeCellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Todoey"
        
        if let tempArray = self.defaults.array(forKey: TDLConst.kTodoListArray) as? [String] {
            itemArray = tempArray
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.backgroundColor = #colorLiteral(red: 0.9306189418, green: 0.7211485505, blue: 0, alpha: 1)
        
        let rightBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action:#selector(addButtonPressed))
        rightBtn.tintColor = .white
        navigationItem.rightBarButtonItem = rightBtn
    }
    
    //MARK: - Add New Items
    @objc func addButtonPressed() {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Creat new item"
        }
        
        let addAction = UIAlertAction(title: "Add Item", style: .default) { action in
            guard let text = alert.textFields?.first?.text else {return}
            self.itemArray.append(text)
            self.defaults.set(self.itemArray, forKey: TDLConst.kTodoListArray)
            self.defaults.synchronize()
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Table view data source & delegate
extension TDLHomeController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) else {return}
        cell.accessoryType = cell.accessoryType == .checkmark ? .none : .checkmark
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
