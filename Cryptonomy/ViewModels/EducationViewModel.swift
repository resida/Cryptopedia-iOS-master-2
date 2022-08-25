
//
//  ViewModel.swift
//  Resources
//
//

import UIKit
import FirebaseDatabase
import PKHUD

typealias CoursesCompletion = (_ result: [Courses], _ error:String?) -> ()
typealias ResourcesCompletion = (_ result: [Resource], _ error:String?) -> ()
typealias DictionaryCompletion = (_ result: [DictResponse], _ error:String?) -> ()

class EducationViewModel: NSObject {

    //MARK: - Public Variables
    
    var ref: DatabaseReference!
    
    //MARK: - Init
    
    override init() {
        super.init()
        ref = Database.database().reference()
    }
    
    //MARK: - Get All Courses
    
    func getAllCourses(completion: CoursesCompletion!) {
        var arrCourses: [Courses] = []
        Common.showLoading()
        self.ref.child("courses").observeSingleEvent(of: .value, with: { (snapshot) in
            Common.hideLoading()
            if snapshot.childrenCount != 0 {
                for child in snapshot.children {
                    let childSnap = child as? DataSnapshot
                    let course = Courses.exportCoursesFromSnapshot(childSnap!)
                    arrCourses.append(course)
                }
                completion(arrCourses, nil)
            } else {
                completion([], "No records found")
            }
        })
    }
    
    func getAllDictionaryData(completion: DictionaryCompletion!) {
        var arrDictionary: [DictResponse] = []
        Common.showLoading()
        self.ref.child("dictionary").observeSingleEvent(of: .value, with: { (snapshot) in
            Common.hideLoading()
            if snapshot.childrenCount != 0 {
                for child in snapshot.children {
                    let childSnap = child as? DataSnapshot
                    let dict = DictResponse.exportDictFromSnapshot(childSnap!)
                    arrDictionary.append(dict)
                }
                completion(arrDictionary, nil)
            } else {
                completion([], "No records found")
            }
        })
    }
    
    //MARK: - Get All Resouces
    
    func getAllResouces(completion: ResourcesCompletion!) {
        var arrResources: [Resource] = []
        Common.showLoading()
        self.ref.child("resources").observeSingleEvent(of: .value, with: { snapshot in
            Common.hideLoading()
            if snapshot.childrenCount != 0 {
                for child in snapshot.children {
                    let childSnap = child as? DataSnapshot
                    let course = Resource.exportResourceFromSnapshot(childSnap!)
                    arrResources.append(course)
                }
                completion(arrResources, nil)
            } else {
                completion([], "No records found")
            }
        })
    }
}
