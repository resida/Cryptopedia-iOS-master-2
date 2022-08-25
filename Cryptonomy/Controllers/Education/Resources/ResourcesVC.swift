//
//  ViewController.swift
//  Resources
//
//

import UIKit
import SwiftWebVC

class ResourcesVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Public Variables
    var arrResources: [Resource] = []
    let viewModel = EducationViewModel()
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeOnce()
        //self.readJSONData()
        self.readDataFromFirebase()
    }

    //MARK: - Common Init
    
    func initializeOnce() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
    }
    
    //MARK: - Read Json Data
    
    func readJSONData() {
        if let path = Bundle.main.path(forResource: "resources", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let resources = jsonResult["resources"] as? [[String: AnyObject]] {
                    for item in resources {
                        let resource = Resource.dataWithInfo(object: item)
                        self.arrResources.append(resource)
                    }
                }
            } catch {
                
            }
        }
    }
    
    func readDataFromFirebase() {
        viewModel.getAllResouces { [weak self] (arrResources, error) in
            if arrResources.count != 0 {
                guard let strongSelf = self else { return }
                strongSelf.arrResources = arrResources
                strongSelf.tableView.reloadData()
            } else {
                print(error!)
            }
        }
    }
}

extension ResourcesVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrResources.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tmpSection = self.arrResources[section]
        
        return tmpSection.arrItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResourceListCell") as! ResourceListCell
        let tmpSection = self.arrResources[indexPath.section]
        let item = tmpSection.arrItems[indexPath.row]
        cell.configureResource(of: item)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tmpSection = self.arrResources[section]
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        view.backgroundColor = UIColor.white
        
        let label = UILabel(frame: CGRect(x: 15.0, y: 5, width: UIScreen.main.bounds.width-20, height: 30))
        label.text = tmpSection.title
        label.font = UIFont.circularMedium(16.0)
        label.textColor = .black
        view.addSubview(label)
        
        return view
    }
}

extension ResourcesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tmpSection = self.arrResources[indexPath.section]
        let item = tmpSection.arrItems[indexPath.row]
        guard let url = item.url else {
            return
        }
        
        self.openWebViewInApp(at: url, title: "Resources")
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension ResourcesVC: SwiftWebVCDelegate {
    func didStartLoading() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didFinishLoading(success: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
}
