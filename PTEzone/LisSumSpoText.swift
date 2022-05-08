//
//  LisSumSpoText.swift
//  PTEzone
//
//  Created by Owner on 5/5/22.
//


import UIKit

class LisSumSpoText: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let listSum: [String] = ["Abstraction","DNA","English","Business Freedom","Survey","AI"]
    let cellReuseIdentifier = "sumCell"
    
    @IBOutlet weak var tableSum: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register the table view cell class and its reuse id
        self.tableSum.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // (optional) include this line if you want to remove the extra empty cell divider lines
        // self.tableView.tableFooterView = UIView()

        // This view controller itself will provide the delegate methods and row data for the table view.
        tableSum.delegate = self
        tableSum.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listSum.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableSum.dequeueReusableCell(withIdentifier: cellReuseIdentifier)! as UITableViewCell
                
        // set the text from the data model
        cell.textLabel?.text = self.listSum[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destination = DetailLisSumSpoText() // Your destination
        navigationController?.pushViewController(destination, animated: true)
    }

}

