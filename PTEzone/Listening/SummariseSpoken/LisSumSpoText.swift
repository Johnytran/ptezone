//
//  LisSumSpoText.swift
//  PTEzone
//
//  Created by Owner on 5/5/22.
//


import UIKit
import FirebaseDatabaseInternal


class LisSumSpoText: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var messages: [SummaryLiss]! = []
    let cellReuseIdentifier = "sumCell"
    
    
    @IBOutlet weak var tableSum: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register the table view cell class and its reuse id
        self.tableSum.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableSum.delegate = self
        tableSum.dataSource = self
        self.registerTableViewCells()
        
        self.messages.removeAll()
        let ref = Database.database().reference().child("SummarySpokenText")


        ref.observeSingleEvent(of: .value, with: { (snap : DataSnapshot)  in
            
            if let snapshots = snap.children.allObjects as? [DataSnapshot] {
                for sn in snapshots {
                    if let lesson = sn.value as? Dictionary<String, AnyObject> {
                        let tmpSummary = SummaryLiss()
                        tmpSummary.setValue(tmpID: sn.key,
                                            tmpTilte: lesson["title"] as! String,
                                            tmpAudio: lesson["audio"] as! String,
                                            tmpAnswer: lesson["answer"] as! String)
                        self.messages.append(tmpSummary)
//                        print(lesson["title"]!)
                    }
                }
            }
            
            self.tableSum.reloadData()
            }) { (err: Error) in


                print("\(err.localizedDescription)")

            }
        
    }
    
    private func registerTableViewCells() {
        let customCell = UINib(nibName: "LisSumTableViewCell",
                                  bundle: nil)
        self.tableSum.register(customCell,
                                forCellReuseIdentifier: "LisSumTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let cell = tableSum.dequeueReusableCell(withIdentifier: "LisSumTableViewCell") as? LisSumTableViewCell {
            let tmpObj: SummaryLiss = self.messages[indexPath.row]
            cell.lblTitle?.text = tmpObj.getTitle()
           
            
            return cell
        }
        
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let tmpObj: SummaryLiss = self.messages[indexPath.row]
        self.performSegue(withIdentifier: "dlsst", sender: tmpObj)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dlsst" && sender is SummaryLiss {
            let destination = segue.destination as! LisDetailSST
            destination.objSummaryLiss = sender as? SummaryLiss
            let e = sender as! SummaryLiss
            print(e)
        }
    }
    

    
}

