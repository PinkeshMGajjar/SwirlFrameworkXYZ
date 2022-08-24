//
//  PlayPauseButton.swift
//  InStore Console
//
//  Created by Atirek Pothiwala on 17/04/20.
//  Copyright © 2020 GetNatty. All rights reserved.
//

import UIKit
import AVKit
import NotificationCenter

protocol PlayerDelegate {
    func onPlayerUpdate(hide: Bool)
}

class PlayPauseButton: DesignableButton {
    
    private var timer: Timer?
    private var kvoRateContext = 0
    public var player: AVPlayer?
    public var delegate: PlayerDelegate?
    
    public var isPlaying: Bool {
        return player?.rate != 0 && player?.error == nil
    }

    private func addObservers() {
        self.player?.addObserver(self, forKeyPath: "rate", options: .new, context: &kvoRateContext)
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }

    @objc func playerDidFinishPlaying(notification: NSNotification) {
        self.player?.seek(to: CMTime.zero)
    }
    
    public func setup(_ player: AVPlayer?) {
        self.player = player
        self.player?.automaticallyWaitsToMinimizeStalling = true
        self.player?.cancelPendingPrerolls()
        addTarget(self, action: #selector(self.tapped(_:)), for: .touchUpInside)
        addObservers()
    }

    @objc func tapped(_ sender: DesignableButton) {
        updateStatus()
    }

    private func updateStatus() {
        if isPlaying {
            player?.pause()
        } else {
            player?.play()
        }
    }
    
    public func pause() {
        if isPlaying {
            player?.pause()
        }
    }

    public func play() {
        if !isPlaying {
            player?.play()
        }
    }
    
    @objc func hide(){
        self.delegate?.onPlayerUpdate(hide: true)
    }
    
    private func handleRateChanged() {
        self.isSelected = self.isPlaying
        self.delegate?.onPlayerUpdate(hide: false)
        
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(
            timeInterval: TimeInterval(3),
            target      : self,
            selector    : #selector(self.hide),
            userInfo    : nil,
            repeats     : false)

    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let context = context else { return }

        switch context {
        case &kvoRateContext:
            handleRateChanged()
        default:
            break
        }
    }
}
