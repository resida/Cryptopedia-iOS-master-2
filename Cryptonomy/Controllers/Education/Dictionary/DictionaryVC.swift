//
//  DictionaryVC.swift
//  Cryptonomy
//
//

import UIKit

class DictionaryVC: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK:- Public Variables
    var arrReponse: [DictResponse] = []
    var arrFilterdResponse: [DictResponse] = []
    let viewModel = EducationViewModel()
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        
        //self.readJSONData()
        self.readDataFromFirebase()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let response = sender as? DictResponse else { return }
        
        if segue.identifier == "showDictionaryDetailVC" {
            let destination = segue.destination as! DictionaryDetailVC
            destination.response = response
        }
    }

    //MARK: - Read Json Data
    
    func readJSONData() {
        if let path = Bundle.main.path(forResource: "cryptionary-resources", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let terms = jsonResult["Crypto-Terms"] as? [String: AnyObject] {
                    var tmpResults: [DictResponse] = []
                    for (key, value) in terms {
                        let tmpObj = value as! [String: AnyObject]
                        let dictData = DictData(data: tmpObj)
                        let response = DictResponse(key: key, data: dictData)
                        tmpResults.append(response)
                    }
                    self.arrReponse = tmpResults.sorted(by: {
                        return $0.key < $1.key
                    })
                    self.arrFilterdResponse = self.arrReponse
                }
            } catch {
                
            }
        }
    }
    
    func readDataFromFirebase() {
        viewModel.getAllDictionaryData { [weak self] (arrResponseData, error) in
            if arrResponseData.count != 0 {
                guard let strongSelf = self else { return }
                strongSelf.arrReponse = arrResponseData
                strongSelf.arrFilterdResponse = arrResponseData
                strongSelf.tableView.reloadData()
            } else {
                print(error!)
            }
        }
    }
    
    func searchBarEmpty() -> Bool {
        return ((searchBar.text?.isEmpty)! || (searchBar.text?.trim().isEmpty)!)
    }
    
    func textEmpty(_ text: String?) -> Bool {
        return ((text?.isEmpty)! || (text?.trim().isEmpty)!)
    }

    func searchUsingData(_ searchText: String) {
        if self.searchBarEmpty() {
            self.arrFilterdResponse.removeAll()
            self.arrFilterdResponse = self.arrReponse
        } else {
            let filterdData = self.arrReponse.filter { $0.key.lowercased().contains(searchText.lowercased()) }
            self.arrFilterdResponse = filterdData
        }
        self.tableView.reloadData()
    }
}

extension DictionaryVC: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrFilterdResponse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier) else {
                return UITableViewCell(style: .default, reuseIdentifier: UITableViewCell.identifier)
            }
            return cell
        }()
        
        let response = self.arrFilterdResponse[indexPath.row]
        cell.textLabel?.text = response.key.capitalized
        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.font = UIFont.circularBook(16.0)
        cell.selectionStyle = .none
        
        return cell
    }
}

extension DictionaryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let response = self.arrFilterdResponse[indexPath.row]
        self.performSegue(withIdentifier: "showDictionaryDetailVC", sender: response)
    }
}

extension DictionaryVC: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.arrFilterdResponse.removeAll()
        self.arrFilterdResponse = self.arrReponse
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchUsingData(searchText)
    }
}
