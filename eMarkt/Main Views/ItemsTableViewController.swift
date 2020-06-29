//
//  ItemsTableViewController.swift
//  eMarkt
//
//  Created by Alex Codreanu on 26/06/2020.
//  Copyright © 2020 Alex Codreanu. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift

class ItemsTableViewController: UITableViewController {

    //MARK: - Variables
    var category: Category?
    var itemArray: [Item] = []
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //getting rid of empty cells
        tableView.tableFooterView = UIView()
        
        self.title = category?.name
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if category != nil {
           loadItems()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell
        cell.generateCell(itemArray[indexPath.row])
        
        return cell
    }
    
    //MARK: - Tableview delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        showItemView(itemArray[indexPath.row])
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemToAddItemSegue"{
            let vc = segue.destination as! AddItemViewController
            vc.category = category!
        }
    }
    
    private func showItemView(_ item: Item){
        let itemVC = UIStoryboard.init(name: "Main", bundle: nil)
            .instantiateViewController(identifier: "itemView") as! ItemViewController
        itemVC.item = item
        self.navigationController?.pushViewController(itemVC, animated: true)
        
        
    }
    
    //MARK: - Load items from Firebase
    
    private func loadItems(){
        downloadItemsFromFirebase(withCategoryID: category!.id) { (items) in
            self.itemArray = items
            self.tableView.reloadData()
        }
    }

}
extension ItemsTableViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "There are no items to display!")
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "emptyData")
    }
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "Come back later or add an item!")
    }
}

