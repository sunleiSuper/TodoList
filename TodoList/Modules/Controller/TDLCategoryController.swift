//
//  TDLCategoryController.swift
//  TodoList
//
//  Created by 孙磊 on 2022/6/14.
//

import UIKit
import CoreData

class TDLCategoryController: TDLBaseTVController {

    //MARK: - Property
    let cellID = "CategoryCellID"
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var itemArray : [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Todoey"
        loadTodoList()
        configureSubView()
    }
    
    func configureSubView() {
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.backgroundColor = #colorLiteral(red: 0.9306189418, green: 0.7211485505, blue: 0, alpha: 1)
        
        let rightBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action:#selector(addButtonPressed))
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
            let model = Category(context: self.context)
            model.name = text

            self.itemArray.append(model)
            self.saveTodoListData()
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Data Base
    func saveTodoListData() {
        do {
            try context.save()
        } catch {
            TDLLog("Error saving context \(error)")
        }
    }
    
    func loadTodoList(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            itemArray = try context.fetch(request)
        } catch {
            TDLLog("Error fetching data from context \(error)")
        }
    }
}

// MARK: - Table view data source & delegate
extension TDLCategoryController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let model = itemArray[indexPath.row]
        cell.textLabel?.text = model.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(TDLHomeController(), animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
