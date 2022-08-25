//
//  VideoPlaybackVC.swift
//  Cryptonomy
//

import UIKit
import youtube_ios_player_helper

class VideoPlaybackVC: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet weak var tableHeaderViewWrapper: UIView!
    @IBOutlet weak var player: YTPlayerView!
    
    //MARK: - Public Variables
    var currentCourse : Courses!
    var currentIndex : Int = 0
    var videoPlayerView: VideoPlayerView!
    
    //MARK: - View life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeOnce()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.layoutIfNeeded()
    }
    
    func initializeOnce() {
        self.title = self.currentCourse.title
        
        self.tableView.tableFooterView = UIView()
        self.tableView.register(VideoPlayerView.nib, forHeaderFooterViewReuseIdentifier: VideoPlayerView.identifier)
        self.tableView.rowHeight = 100;
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func preparePlayer(_ url: String?){
        guard let videoURL = url else {
            return
        }
        
        let playvarsDic = ["controls": 1, "playsinline": 1, "autohide": 1, "showinfo": 1, "autoplay": 1, "modestbranding": 1]
        self.player.load(withVideoId: videoURL, playerVars: playvarsDic)
        self.player.delegate = self
    }
}

extension VideoPlaybackVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentCourse.arrVideos.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CourceTopCell") as! CourseOtherCell
            let currentVideo = self.currentCourse.arrVideos[currentIndex]
            cell.lblTitle.attributedText =  NSMutableAttributedString().changeTextWithSpacing(lineSpacing: 8.0, text: currentVideo.title!, font: UIFont.circularMedium(15.0), fontColor: UIColor.c_CommonDarkColor)
            cell.lblDesc.attributedText = NSMutableAttributedString().changeTextWithSpacing(lineSpacing: 6.0, text: currentVideo.vDescription!, font: UIFont.circularBook(13.0), fontColor: UIColor.c_CommonLightColor)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CourseOtherCell.identifier) as! CourseOtherCell
            cell.configureVideo(of: self.currentCourse.arrVideos[indexPath.row-1])
            cell.playIcon.isHidden = indexPath.row - 1 != currentIndex
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: VideoPlayerView.identifier) as! VideoPlayerView
        let currentVideo = self.currentCourse.arrVideos[currentIndex]
        view.preparePlayer(currentVideo.videoURL)
        return view
    }
}

extension VideoPlaybackVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            return
        }
        currentIndex = indexPath.row-1
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return UITableView.automaticDimension
        } else {
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let currentVideo = self.currentCourse.arrVideos[currentIndex]
        if let _ = currentVideo.videoURL {
            return 250
        }
        
        return 0
    }
}

extension VideoPlaybackVC: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        self.player.playVideo()
    }
}
