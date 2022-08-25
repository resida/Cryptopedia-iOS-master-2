//
//  UIStoryboardExtention.swift
//  Cryptonomy
//

import Foundation
import UIKit

extension UIStoryboard {

    /// Fetch view controller from storyboard with use of class type
    public func instantiateVC<T>(_ identifier: T.Type) -> T? {
        let storyboardID = String(describing: identifier)
        if let vc = instantiateViewController(withIdentifier: storyboardID) as? T {
            return vc
        } else {
            return nil
        }
    }
}

extension UIStoryboard {

    // MARK: - storyboard declaration -
    static var mainStoryboard: UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main) }
    static var educationStoryboard: UIStoryboard { return UIStoryboard(name: "Education", bundle: Bundle.main) }
    static var marketStoryboard: UIStoryboard { return UIStoryboard(name: "Market", bundle: Bundle.main) }

    // MARK:- Controllers
    
    static var marketListVC: MarketListVC { return UIStoryboard.marketStoryboard.instantiateVC(MarketListVC.self)! }
    static var icoVC: IcoVC { return UIStoryboard.marketStoryboard.instantiateVC(IcoVC.self)! }
    static var favoritesVC: FavoritesVC { return UIStoryboard.marketStoryboard.instantiateVC(FavoritesVC.self)! }
    static var marketDetailVC: MarketDetailVC { return UIStoryboard.marketStoryboard.instantiateVC(MarketDetailVC.self)! }

    //MARK: - Education Controllers
    
    static var coursesVC: CoursesVC { return UIStoryboard.educationStoryboard.instantiateVC(CoursesVC.self)! }
    static var dictionaryVC: DictionaryVC { return UIStoryboard.educationStoryboard.instantiateVC(DictionaryVC.self)! }
    static var resourcesVC: ResourcesVC { return UIStoryboard.educationStoryboard.instantiateVC(ResourcesVC.self)! }
    
    // MARK:- Controllers
    
    class func homeVC() -> HomeVC { return UIStoryboard.mainStoryboard.instantiateVC(HomeVC.self)! }
    class func marketVC() -> MarketVC { return UIStoryboard.mainStoryboard.instantiateVC(MarketVC.self)! }
    class func searchVC() -> SearchVC { return UIStoryboard.mainStoryboard.instantiateVC(SearchVC.self)! }
}
