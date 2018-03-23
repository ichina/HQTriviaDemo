//
//  VideoPlayer.swift
//  HQTriviaDemo
//
//  Created by Chingis Gomboev on 21/03/18.
//  Copyright © 2018 ching. All rights reserved.
//

import AVFoundation
import UIKit

public class VideoPlayer {

  public var isMuted = true {
    didSet {
      playerLayer.player?.isMuted = isMuted
    }
  }

  public var willLoopVideo = true
  public lazy var playerLayer = AVPlayerLayer()
  private var applicationWillEnterForegroundObserver: NSObjectProtocol?
  private var playerItemDidPlayToEndObserver: NSObjectProtocol?
  private var viewBoundsObserver: NSKeyValueObservation?

  public init() {
    applicationWillEnterForegroundObserver = NotificationCenter.default.addObserver(
      forName: .UIApplicationWillEnterForeground,
      object: nil,
      queue: .main) { [weak self] _ in
        self?.playerLayer.player?.play()
    }
  }

  public func play(view: UIView,
                   videoName: String,
                   videoType: String,
                   isMuted: Bool = false,
                   willLoopVideo: Bool = true,
                   setAudioSessionAmbient: Bool = true) throws {
    guard let path = Bundle.main.path(forResource: videoName, ofType: videoType) else {
      throw VideoBackgroundError.videoNotFound((name: videoName, type: videoType))
    }
    let url = URL(fileURLWithPath: path)
    play(
      view: view,
      url: url,
      isMuted: isMuted,
      willLoopVideo: willLoopVideo,
      setAudioSessionAmbient: setAudioSessionAmbient
    )
  }

  public func play(view: UIView,
                   url: URL,
                   isMuted: Bool = true,
                   willLoopVideo: Bool = true,
                   setAudioSessionAmbient: Bool = true) {
    cleanUp()

    if setAudioSessionAmbient {
      if #available(iOS 10.0, *) {
        try? AVAudioSession.sharedInstance().setCategory(
          AVAudioSessionCategoryAmbient,
          mode: AVAudioSessionModeDefault
        )
        try? AVAudioSession.sharedInstance().setActive(true)
      }
    }

    self.willLoopVideo = willLoopVideo

    let player = AVPlayer(url: url)
    player.actionAtItemEnd = .none
    player.isMuted = isMuted
    player.play()

    playerLayer = AVPlayerLayer(player: player)
    playerLayer.frame = view.bounds
    playerLayer.videoGravity = .resizeAspectFill
    playerLayer.zPosition = -1
    view.layer.insertSublayer(playerLayer, at: 0)

    playerItemDidPlayToEndObserver = NotificationCenter.default.addObserver(
      forName: .AVPlayerItemDidPlayToEndTime,
      object: player.currentItem,
      queue: .main) { [weak self] _ in
        if let willLoopVideo = self?.willLoopVideo, willLoopVideo {
          self?.restart()
        }
    }

    viewBoundsObserver = view.layer.observe(\.bounds) { [weak self] view, _ in
      DispatchQueue.main.async {
        self?.playerLayer.frame = view.bounds
      }
    }
  }

  public func pause() {
    playerLayer.player?.pause()
  }

  public func resume() {
    playerLayer.player?.play()
  }

  public func restart() {
    playerLayer.player?.seek(to: kCMTimeZero)
    playerLayer.player?.play()
  }

  private func cleanUp() {
    playerLayer.player = nil
    if let playerItemDidPlayToEndObserver = playerItemDidPlayToEndObserver {
      NotificationCenter.default.removeObserver(playerItemDidPlayToEndObserver)
    }
    viewBoundsObserver?.invalidate()
  }

  deinit {
    cleanUp()
    if let applicationWillEnterForegroundObserver = applicationWillEnterForegroundObserver {
      NotificationCenter.default.removeObserver(applicationWillEnterForegroundObserver)
    }
  }
}

public enum VideoBackgroundError: LocalizedError {
  /// Video with given name and type could not be found.
  case videoNotFound((name: String, type: String))

  public var errorDescription: String? {
    switch self {
    case . videoNotFound(let videoInfo):
      return "Could not find \(videoInfo.name).\(videoInfo.type)."
    }
  }
}

