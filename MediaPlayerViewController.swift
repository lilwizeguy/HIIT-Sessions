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
        DispatchQueue
            .global(qos: .userInitiated).async {
            if (self.musicPlayer.currentPlaybackTime > 2) {
                self.musicPlayer.skipToBeginning()
            }
            else {
                self.musicPlayer.skipToPreviousItem()
                self.updateTitles()
                
            }
        }
        
    }
    
    @IBAction func onNext(_ sender: Any) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.musicPlayer.skipToNextItem()
            self.updateTitles()
        }

    }
    
    
    func isPlaying() -> Bool {
        return self.musicPlayer.playbackState == MPMusicPlaybackState.playing

    }
    
    func setForPause() {
        
        DispatchQueue.main.async {
            self.playPauseButton.layer.add(self.titleTransition(), forKey: kCATransitionFade)
            self.playPauseButton.setImage(#imageLiteral(resourceName: "play-button"), for: .normal)
        }
        
    }
    
    func setForPlaying() {
        DispatchQueue.main.async {
            self.playPauseButton.layer.add(self.titleTransition(), forKey: kCATransitionFade)
            self.playPauseButton.setImage(#imageLiteral(resourceName: "pause-button"), for: .normal)
        }
    }
    
    func setPlayPauseImage() {
        var image = #imageLiteral(resourceName: "play-button")
        let audioPlaying = isPlaying()
        if audioPlaying == true {
            image = #imageLiteral(resourceName: "pause-button")
        }
        
        DispatchQueue.main.async {
            self.playPauseButton.imageView?.layer.add(self.titleTransition(), forKey: kCATransitionFade)
            self.playPauseButton.setImage(image, for: .normal)
        }
            
    }
    
    @IBAction func onPlayPause(_ sender: Any) {
        
        if isPlaying() {
            musicPlayer.pause()
            self.setForPause()
        }
        else {
            musicPlayer.play()
            self.setForPlaying()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        DispatchQueue.global(qos: .userInitiated).async {
            let query = MPMediaQuery.songs()
            if (self.musicPlayer.nowPlayingItem == nil) {
                self.musicPlayer.setQueue(with: query)
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    func titleTransition() -> CATransition {
        let animation = CATransition.init()
        animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
        animation.type = kCATransitionFade
        animation.duration = 0.2
        return animation
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateTitles() {
        guard musicPlayer.nowPlayingItem != nil else {
            return
        }
        DispatchQueue.main.async {
            self.songTitleLabel.layer.add(self.titleTransition(), forKey: kCATransitionFade)
            self.songDescriptionLabel.layer.add(self.titleTransition(), forKey: kCATransitionFade)
            
            self.songTitleLabel.text = self.musicPlayer.nowPlayingItem?.title
            self.songDescriptionLabel.text = self.musicPlayer.nowPlayingItem?.artist
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateTitles()
        self.setPlayPauseImage()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MediaPlayerViewController.willEnterForeground), name: NSNotification.Name(rawValue: "willEnterForeground"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    func willEnterForeground() {
        self.updateTitles()
        self.setPlayPauseImage()
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
