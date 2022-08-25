//
//  RedFlagsVC.swift
//  Cryptonomy
//
//

import UIKit

class RedFlagsVC: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet var tableView: UITableView!
    
    //MARK: - Public Variables
    var arrRedFlags: [String] = []
    
    //MARK: - View life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.commonInit()
    }

    //MARK:- Common Init
    
    func commonInit() {
        self.title = "Red Flags"
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableView.automaticDimension
        
        self.tableView.dataSource = self
    }
}

extension RedFlagsVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrRedFlags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RedFlagsCell.identifier) as! RedFlagsCell
        cell.lblNo.text = "\(indexPath.row+1)" + "."
        cell.lblText.text = self.arrRedFlags[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
}
