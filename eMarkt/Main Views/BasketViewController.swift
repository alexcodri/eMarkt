//
//  BasketViewController.swift
//  eMarkt
//
//  Created by Alex Codreanu on 27/06/2020.
//  Copyright © 2020 Alex Codreanu. All rights reserved.
//

import UIKit
import JGProgressHUD
class BasketViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalItemsLabel: UILabel!
    @IBOutlet weak var checkoutButton: UIButton!
    
    //MARK: - Variables
    var basket: Basket?
    var allItems: [Item] = []
    var purchasedItemsIDs: [String] = []
    let hud = JGProgressHUD(style: .dark)
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = footerView
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchBasketFromFirebase()
        //TODO: - check if user is logged in
    }
    
    //MARK: - IBActions
    @IBAction func checkoutButtonPressed(_ sender: Any) {
    }
    
    //MARK: - Download basket functions
    private func fetchBasketFromFirebase(){
        downloadBasketFromFirebase("123") { (basket) in
            self.basket = basket
            self.getBasketItems()
        }
    }
    
    private func getBasketItems(){
        if basket != nil{
            downloadItemsFromFirebaseByItemID(withIDs: basket!.itemIDs) { (allItems) in
                self.allItems = allItems
                self.updateTotalLabel(false)
                self.tableView.reloadData()
                
            }
        }
    }
    
    //MARK: - Helper functions
    
    //EXPLANATION: - calculating total price of items in basket
    private func returnBasketTotalPrice() -> String {
        
        var totalPrice = 0.0
        
        for item in allItems {
            totalPrice += item.price
        }
        return "Total price: " + convertToCurrency(totalPrice)
    }
    
    //EXPLANATION: - showing total number of items in basket
    private func updateTotalLabel(_ isEmpty: Bool){
        if isEmpty {
            totalItemsLabel.text = "0"
            totalLabel.text = returnBasketTotalPrice()
        } else {
            totalItemsLabel.text = "\(allItems.count)"
            totalLabel.text = returnBasketTotalPrice()
            totalLabel.adjustsFontSizeToFitWidth = true
            checkoutButtonStatusUpdate()
        }
    }
    //TODO: update button status
    
    //MARK: - Navigation
    private func showItemView(withItem: Item){
        
        let itemVC = UIStoryboard.init(name: "Main", bundle: nil)
            .instantiateViewController(identifier: "itemView") as! ItemViewController
        itemVC.item = withItem
        self.navigationController?.pushViewController(itemVC, animated: true)
        
    }
    
    //MARK: - Control checkout button
    private func checkoutButtonStatusUpdate(){
        checkoutButton.isEnabled = allItems.count > 0
        
        if checkoutButton.isEnabled {
            checkoutButton.backgroundColor = .gray
        } else {
            disableCheckoutButton()
        }
    }
    
    private func disableCheckoutButton(){
        checkoutButton.isEnabled = false
        checkoutButton.backgroundColor = .white
        
    }
    
    //MARK: - Removing Item from Basket
    private func removeItemFromBasket(itemID: String){
        for i in 0..<basket!.itemIDs.count{
            if itemID == basket!.itemIDs[i] {
                basket!.itemIDs.remove(at: i)
                return
            }
        }
    }
}
//MARK: - Extension
extension BasketViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell
        cell.generateCell(allItems[indexPath.row])
        
        return cell
    }
    
    //MARK: - UITableView Delegate
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
        //EXPLANATION: - allowing user to edit
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //EXPLANATION: - what happens when the user edits
        //EXPLANATION: - what editing style is used
        if editingStyle == .delete {
            //EXPLANATION: - finding the item the user wants to delete
            let itemToDelete = allItems[indexPath.row]
            
            //EXPLANATION: - deleting the item from the local items array and reloading the data
            allItems.remove(at: indexPath.row)
            tableView.reloadData()
            
            //EXPLANATION: - removing the item from de basket via itemID
            removeItemFromBasket(itemID: itemToDelete.id)
            //EXPLANATION: - updating the basket in Firebase
            updateBasketInFirebase(basket!, withValues: [kITEMIDS : basket!.itemIDs]) { (error) in
                if error != nil {
                    print("Error updating the basket!")
                }
                self.getBasketItems()
            }
            
        }
    }
    //EXPLANATION: - deselecting the selected item
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showItemView(withItem: allItems[indexPath.row])
    }
    
    
    
}
