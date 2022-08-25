//
//  VideoPlayerView.swift
//  Cryptonomy
//
//

import UIKit
import youtube_ios_player_helper

class VideoPlayerView: UITableViewHeaderFooterView {

    @IBOutlet var player: YTPlayerView!
    
    func preparePlayer(_ url: String?){
        guard let videoURL = url else {
            return
        }
        
        let playvarsDic = ["controls": 1, "playsinline": 1, "autohide": 1, "showinfo": 1, "autoplay": 1, "modestbranding": 1]
        self.player.load(withVideoId: videoURL, playerVars: playvarsDic)
        self.player.delegate = self
    }
}

extension VideoPlayerView: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        self.player.playVideo()
    }
}
