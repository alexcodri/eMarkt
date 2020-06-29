//
//  PurchaseHistoryTableViewController.swift
//  eMarkt
//
//  Created by Alex Codreanu on 28/06/2020.
//  Copyright © 2020 Alex Codreanu. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift
class PurchaseHistoryTableViewController: UITableViewController {

    //MARK: - Variables
    var itemArray: [Item] = []
    

    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //EXPLANATION: - Getting rid of empty cells in table view
        tableView.tableFooterView = UIView()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadItems()
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
    //EXPLANATION: - deselecting the selected item
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //EXPLANATION: - opening the View that contains the selected item
        showItemView(withItem: itemArray[indexPath.row])
    }
    
    //MARK: - Helper functions
    
    private func loadItems(){
        downloadItemsFromFirebaseByItemID(withIDs: MUser.currentUser()!.purchasedItemIDs) { (allItems) in
            self.itemArray = allItems
            self.tableView.reloadData()
        }
    }
    
    //MARK: - Navigation
    private func showItemView(withItem: Item){
        
        let itemVC = UIStoryboard.init(name: "Main", bundle: nil)
            .instantiateViewController(identifier: "itemView") as! ItemViewController
        itemVC.item = withItem
        self.navigationController?.pushViewController(itemVC, animated: true)
        
    }
}

extension PurchaseHistoryTableViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "There are no items to display!")
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "emptyData")
    }
}

