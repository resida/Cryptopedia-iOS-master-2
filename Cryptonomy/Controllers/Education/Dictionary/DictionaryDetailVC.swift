//
//  DictionaryDetailVC.swift
//  Cryptonomy
//
//

import UIKit
import youtube_ios_player_helper

class DictionaryDetailVC: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var player: YTPlayerView!
    @IBOutlet var playerHeightConstraint: NSLayoutConstraint!
    
    //MARK:- Public Variables
    var response: DictResponse!
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeOnce()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeOnce() {
        self.title = response.key.capitalized
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .none
        
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
        
        if let url = self.response.data.youtubeLink, url != "" {
            let playvarsDic = ["controls": 1, "playsinline": 1, "autohide": 1, "showinfo": 1, "autoplay": 1, "modestbranding": 1]
            self.player.load(withVideoId: url, playerVars: playvarsDic)
            self.player.delegate = self
        } else {
            self.playerHeightConstraint.constant = 0
        }
    }
}

extension DictionaryDetailVC: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DictDetailCell.identifier) as! DictDetailCell
        cell.lblTitle.attributedText =  NSMutableAttributedString().changeTextWithSpacing(lineSpacing: 8.0, text: self.response.data.term!, font: UIFont.circularMedium(17.0), fontColor: UIColor.c_CommonDarkColor)
        cell.lblDescription.attributedText = NSMutableAttributedString().changeTextWithSpacing(lineSpacing: 4.0, text: self.response.data.definations!, font: UIFont.circularBook(13.0), fontColor: UIColor.c_CommonLightColor)
        cell.selectionStyle = .none
        
        return cell
    }
}

extension DictionaryDetailVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension DictionaryDetailVC: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        self.player.playVideo()
    }
}
