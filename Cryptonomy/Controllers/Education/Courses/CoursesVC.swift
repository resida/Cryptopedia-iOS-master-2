//
//  CoursesVC.swift
//  Cryptonomy
//
//

import UIKit

class CoursesVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Public Variables
    var arrCourses: [Courses] = []
    let viewModel = EducationViewModel()
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeOnce()
        //self.readJsonCourses()
        self.readDataFromFirebase()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let currentCourse = sender as? Courses else { return }
        
        if segue.identifier == "showVideoPlaybackScreen" {
            let destination = segue.destination as! VideoPlaybackVC
            destination.currentCourse = currentCourse
        }
    }
    
    func initializeOnce() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .none
        
        self.tableView.sectionFooterHeight = 0
        self.tableView.sectionHeaderHeight = 0
        
        self.tableView.register(CourseHeaderView.nib, forHeaderFooterViewReuseIdentifier: "CourseHeaderView")
    }
    
    func readJsonCourses() {
        if let path = Bundle.main.path(forResource: "courses", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let courses = jsonResult["courses"] as? [[String: AnyObject]] {
                    for item in courses {
                        let course = Courses.dataWithInfo(object: item)
                        self.arrCourses.append(course)
                    }
                }
            } catch {
                
            }
        }
    }
    
    func readDataFromFirebase() {
        viewModel.getAllCourses { [weak self] (arrCourses, error) in
            if arrCourses.count != 0 {
                guard let strongSelf = self else { return }
                strongSelf.arrCourses = arrCourses
                strongSelf.tableView.reloadData()
            } else {
                print(error!)
            }
        }
    }
    
    func getCourse(at indexPath: IndexPath) -> Courses {
        var course: Courses? = nil
        if indexPath.section == 0 {
            course = self.arrCourses[0]
        } else {
            course = self.arrCourses[indexPath.row + 1]
        }
        return course!
    }
    
    //MARK: - Button tap events
    
    @IBAction func btnCorporateEducationTapped(_ sender: Any) {
        self.openWebViewInApp(at: Global.corporateEducationURL)
    }
}

extension CoursesVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? self.arrCourses.count != 0 ? 1 : 0 : self.arrCourses.count-1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let course = self.getCourse(at: indexPath)
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CourseTopCell") as! CourseTopCell
            cell.configureCourse(of: course)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CourseOtherCell") as! CourseOtherCell
            cell.configureCourse(of: course)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CourseHeaderView") as! CourseHeaderView
        if section == 0 {
            view.lblTitle.text = "Get Started"
            view.btnCorporateEducation.isHidden = true
            view.lineView.isHidden = false
        } else {
            view.lblTitle.text = "More Courses"
            view.btnCorporateEducation.isHidden = false
            view.lineView.isHidden = true
            view.btnCorporateEducation.addTarget(self, action: #selector(btnCorporateEducationTapped(_:)), for: .touchUpInside)
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return self.arrCourses.count != 0 ? 60 : 0.01
        } else {
            return self.arrCourses.count > 1 ? 60 : 0.01
        }
    }
}

extension CoursesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 200 : 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let course = self.getCourse(at: indexPath)
        self.performSegue(withIdentifier: "showVideoPlaybackScreen", sender: course)
    }
}
