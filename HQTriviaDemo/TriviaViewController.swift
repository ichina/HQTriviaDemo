//
//  ViewController.swift
//  HQTriviaDemo
//
//  Created by Chingis Gomboev on 21/03/2018.
//  Copyright © 2018 Chingis Gomboev. All rights reserved.
//

import UIKit
import Foundation

class TriviaViewController: UIViewController {

  @IBOutlet var triviaView: TriviaView!

  override func viewDidLoad() {
    super.viewDidLoad()

    try? triviaView.player.play(view: triviaView.videoView, videoName: "bg-video", videoType: "mov")
    triviaView.videoTransform = VideoLayerTransform(layer: triviaView.player.playerLayer, view: triviaView.videoView)
    triviaView.questionView.answerButtons.forEach { (btn) in
      btn.addTarget(self, action: #selector(TriviaViewController.buttonTouched(_:)), for: .touchUpInside)
    }
  }

  var isExpanded = true

  @objc
  func buttonTouched(_ sender: Any?) {
    triviaView.hideQuestion()
  }

  @IBAction func questionBtnClicked(_ sender: Any) {
    triviaView.showQuestion()
  }
}


