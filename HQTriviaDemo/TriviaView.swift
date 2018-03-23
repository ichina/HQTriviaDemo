//
//  TriviaView.swift
//  HQTriviaDemo
//
//  Created by Chingis Gomboev on 23/03/2018.
//  Copyright © 2018 Chingis Gomboev. All rights reserved.
//

import UIKit

class TriviaView: UIView {

  var questionView: QuestionView!

  let player = VideoPlayer()
  lazy var videoTransform: VideoLayerTransform = {
    return VideoLayerTransform(layer: player.playerLayer, view: videoView)
  }()

  @IBOutlet weak var showQuestionButton: UIButton!
  @IBOutlet weak var videoView: UIView!
  @IBOutlet weak var countLabel: UILabel!
  @IBOutlet weak var countLabelBotContraint: NSLayoutConstraint!
  @IBOutlet weak var pageControl: UIPageControl!
  @IBOutlet weak var inputImageView: UIImageView!
  
  var isQuestionShown = false

  override func awakeFromNib() {
    super.awakeFromNib()

    let color = Constants.bgColor
    backgroundColor = color
    videoView.backgroundColor = color

    showQuestionButton.layer.cornerRadius = showQuestionButton.frame.width/2

    countLabelBotContraint.isActive = false
    countLabel.alpha = 0
    pageControl.alpha = 0

    questionView = QuestionView.newInstance()
    questionView.translatesAutoresizingMaskIntoConstraints = false
    insertSubview(questionView, at: 0)
    let inset = Constants.questionInsets
    NSLayoutConstraint.activate([
      questionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset.left),
      questionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset.right),
      questionView.topAnchor.constraint(equalTo: topAnchor, constant: inset.top),
      questionView.heightAnchor.constraint(greaterThanOrEqualToConstant: inset.bottom),
      questionView.bottomAnchor.constraint(equalTo: countLabel.topAnchor, constant: -inset.left),
      ])

  }

  func showQuestion() {
    guard !isQuestionShown else { return }
    videoTransform.collapseAndRound()
    questionView.show()
    countLabel.alpha = 1
    pageControl.alpha = 1
    isQuestionShown = true
    setInput(hidden: true)
  }

  func hideQuestion() {
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
      self.questionView.hide()
      self.videoTransform.cancel()
      self.countLabel.alpha = 0
      self.pageControl.alpha = 0
      self.setInput(hidden: false)
    }
    isQuestionShown = false
  }

  private func setInput(hidden: Bool) {
    UIView.animate(withDuration: Constants.animationDuration) {
      self.inputImageView.layer.transform = hidden ? CATransform3DMakeTranslation(0, 50, 0) : CATransform3DIdentity
      self.inputImageView.alpha = hidden ? 0 : 1
    }
  }
}
