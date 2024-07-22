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
        tableSum.delegate = self
        tableSum.dataSource = self
        self.registerTableViewCells()
    }
    
    private func registerTableViewCells() {
        let customCell = UINib(nibName: "LisSumTableViewCell",
                                  bundle: nil)
        self.tableSum.register(customCell,
                                forCellReuseIdentifier: "LisSumTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listSum.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableSum.dequeueReusableCell(withIdentifier: "LisSumTableViewCell") as? LisSumTableViewCell {
            cell.lblTitle?.text = self.listSum[indexPath.row]
            
            return cell
        }
        
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.performSegue(withIdentifier: "dlsst", sender: self)
    }
    

    
}

