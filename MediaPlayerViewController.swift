//
//  MediaPlayerViewController.swift
//  HIIT Sessions
//
//  Created by Immanuel Amirtharaj on 7/5/17.
//  Copyright © 2017 Immanuel Amirtharaj. All rights reserved.
//

import UIKit
import MediaPlayer

class MediaPlayerViewController: UIViewController {

    @IBOutlet var songTitleLabel: UILabel!
    @IBOutlet var songDescriptionLabel: UILabel!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var forwardButton: UIButton!
    @IBOutlet var playPauseButton: UIButton!
    
    let musicPlayer = MPMusicPlayerController.systemMusicPlayer()
    
    
    struct MusicViewModel {
        var songTitle : String;
        var songDescription : String;
        
        init() {
            songTitle = "--"
            songDescription = "--"
        }
        
        init(title : String, description : String) {
            songTitle = title;
            songDescription = description
        }
        
        init (song : MPMediaItem) {
            songTitle = song.title!
            songDescription = song.description
        }
        
    }
    
    
    func updateView(model : MusicViewModel) {
        self.songTitleLabel.text = model.songTitle
        self.songDescriptionLabel.text = model.songDescription
    }
    
    
    @IBAction func onPrevious(_ sender: Any) {
        if (musicPlayer.currentPlaybackTime < 5) {
            musicPlayer.skipToBeginning()
        }
        else {
            musicPlayer.skipToPreviousItem()
            updateTitles()

        }
    }
    
    @IBAction func onNext(_ sender: Any) {
        musicPlayer.skipToNextItem()
        updateTitles()

    }
    
    
    func isPlaying() -> Bool {
        return AVAudioSession.sharedInstance().isOtherAudioPlaying

    }
    
    func setPlayPauseImage() {
        var image = #imageLiteral(resourceName: "play-button")
        let audioPlaying = isPlaying()
        if audioPlaying == true {
            image = #imageLiteral(resourceName: "pause-button")
        }
        
        self.playPauseButton.setImage(image, for: .normal)

    }
    
    @IBAction func onPlayPause(_ sender: Any) {
        self.setPlayPauseImage()
        if isPlaying() {
            musicPlayer.pause()
        }
        else {
            musicPlayer.play()
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setPlayPauseImage()

        let query = MPMediaQuery.songs()
        
        if (musicPlayer.nowPlayingItem == nil) {
            musicPlayer.setQueue(with: query)
        }
        updateTitles()

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateTitles() {
        guard musicPlayer.nowPlayingItem != nil else {
            return
        }
        self.songTitleLabel.text = musicPlayer.nowPlayingItem?.title
        self.songDescriptionLabel.text = musicPlayer.nowPlayingItem?.artist
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}