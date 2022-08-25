//
//  SettingsVC.swift
//  Cryptonomy
//
//

import UIKit
import SwiftyUserDefaults

class SettingsVC: UITableViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var swcPush: UISwitch!
    
    //MARK: - View life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let notOnOff = Defaults[.pushNotification] else { return }
        swcPush.setOn(notOnOff, animated: true)
    }
    
    //MARK: - Button tap events
    
    @IBAction func swcPushValueChanged(_ sender: UISwitch) {
        Defaults[.pushNotification] = sender.isOn
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                self.openWebViewInApp(at: Global.aboutUsURL, title: "About Us")
            } else if indexPath.row == 1 {
                self.openWebViewInApp(at: Global.joinOurCommunityURL, title: "Join Our Community")
            } else if indexPath.row == 2 {
                self.openWebViewInApp(at: Global.supportURL, title: "Support")
            } else if indexPath.row == 3 {
                self.openWebViewInApp(at: Global.contactURL, title: "Contact")
            } else if indexPath.row == 4 {
                self.openWebViewInApp(at: Global.corporateEducationURL, title: "Corporate Education")
            } else if indexPath.row == 5 {
                self.openWebViewInApp(at: Global.blockChainURL, title: "Blockchain Consulting & Development")
            } else if indexPath.row == 6 {
                self.openWebViewInApp(at: Global.termsConditionURL, title: "Terms & Conditions")
            }
        }
    }
}
