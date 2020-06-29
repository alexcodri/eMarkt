//
//  SeachViewController.swift
//  eMarkt
//
//  Created by Alex Codreanu on 29/06/2020.
//  Copyright © 2020 Alex Codreanu. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
class SeachViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var seachOptionView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    
    //MARK: - Variables
    var searchResults: [Item] = []
    var activityIndicator: NVActivityIndicatorView?
    
    
    //MARK: - View lifecycle
    @IBOutlet weak var searchButtonOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        searchTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .ballPulse, color: .black, padding: nil)    }

    //MARK: - IBActions
    
    @IBAction func showSearchBarButtonPressed(_ sender: Any) {
        dismissKeyboard()
        showSearchField()
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
    }
    
    //MARK: - Helper functions
    private func emptyTextField(){
        searchTextField.text = ""
    }
    
    private func dismissKeyboard(){
        self.view.endEditing(true)
    }

    @objc func textFieldDidChange (_ textField: UITextField){
        //EXPLANATION: - if the textField has any kind of text, it will be automatically enabled
        searchButtonOutlet.isEnabled = textField.text != ""
        
        if searchButtonOutlet.isEnabled {
            searchButtonOutlet.backgroundColor = .lightGray
        } else {
            disableSearchButton()
        }
    }
    
    private func disableSearchButton(){
        searchButtonOutlet.isEnabled = false
        searchButtonOutlet.backgroundColor = .lightGray
    }
    
    private func showSearchField(){
        disableSearchButton()
        emptyTextField()
        animateSearchOptionIn()
    }
    
    //MARK: - Animations
    private func animateSearchOptionIn() {
        UIView.animate(withDuration: 0.5) {
            //EXPLANATION: - handling whether the searchOptionView is hidden or not
            self.seachOptionView.isHidden = !self.seachOptionView.isHidden
        }
    }
    
    //MARK: - Activity indicator
    private func showLoadingIndicator() {
        if activityIndicator != nil {
            self.view.addSubview(activityIndicator!)
            activityIndicator!.startAnimating()
        }
    }
    
    private func hideLoadingIndicator() {
        if activityIndicator != nil {
            activityIndicator!.removeFromSuperview()
            activityIndicator!.stopAnimating()
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

extension SeachViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell
        cell.generateCell(searchResults[indexPath.row])
        
        return cell
    }
    
    //MARK: - UITableView delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //EXPLANATION: - opening the View that contains the selected item
        showItemView(withItem: searchResults[indexPath.row])
    }
    
}
