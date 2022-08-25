//
//  EducationVC.swift
//  Cryptonomy
//
//

import UIKit

class EducationVC: UIViewController {
    
    //MARK: - Public Variables
    
    var pageMenu: CAPSPageMenu?

    //MARK: - View life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageMenuInitialization()
    }

    //MARK: - Page Menu Initialization
    
    func pageMenuInitialization() {
        var controllerArray: [UIViewController] = []
        
        let controller1 = UIStoryboard.coursesVC
        controller1.title = "Courses"
        controllerArray.append(controller1)
        
        let controller2 = UIStoryboard.dictionaryVC
        controller2.title = "Dictionary"
        controllerArray.append(controller2)
        
        let controller3 = UIStoryboard.resourcesVC
        controller3.title = "Resources"
        controllerArray.append(controller3)
        
        let parameters: [CAPSPageMenuOption] = [
            .useMenuLikeSegmentedControl(true),
            .menuItemFont(UIFont.circularMedium(16.0)),
            .selectedMenuItemLabelColor(UIColor.c_Blue),
            .unselectedMenuItemLabelColor(UIColor.c_PageMenuDefaultColor),
            .addBottomMenuHairline(false),
            .centerMenuItems(true),
            .menuHeight(40),
            .scrollMenuBackgroundColor(UIColor.white),
            .viewBackgroundColor(UIColor.white),
            .menuItemSeparatorColor(UIColor.white),
            ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height), pageMenuOptions: parameters)
        pageMenu?.delegate = self
        
        self.addChild(pageMenu!)
        self.view.addSubview(pageMenu!.view)
        
        pageMenu!.didMove(toParent: self)
    }
}

extension EducationVC: CAPSPageMenuDelegate {
    func willMoveToPage(_ controller: UIViewController, index: Int) {
        
    }
    
    func didMoveToPage(_ controller: UIViewController, index: Int) {
        
    }
}
