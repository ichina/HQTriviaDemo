//
//  QuestionView.swift
//  HQTriviaDemo
//
//  Created by Chingis Gomboev on 23/03/2018.
//  Copyright © 2018 Chingis Gomboev. All rights reserved.
//

import UIKit

class QuestionView: UIView {

  @IBOutlet weak var textLabel: UILabel!
  @IBOutlet var answerButtons: [AnswerButton]!

  static func newInstance() -> QuestionView {
    return Bundle.main.loadNibNamed("QuestionView", owner: nil, options: nil)?.first as! QuestionView
  }

  override func awakeFromNib() {
    super.awakeFromNib()

    addMask()
    self.layer.transform = Constants.questionTransform
    self.alpha = 0


    if is4Inch {
      textLabel.font = UIFont.systemFont(ofSize: 20)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    addMask()
  }

  func show() {
    UIView.animate(withDuration: Constants.animationDuration, animations: {
      self.layer.transform = CATransform3DIdentity
      self.alpha = 1
    })
  }

  func hide() {
    UIView.animate(withDuration: Constants.animationDuration, animations: {
      self.layer.transform = Constants.questionTransform
      self.alpha = 0
    })
  }

  private func addMask() {
    let rect = bounds.insetBy(dx: 0, dy: 20).offsetBy(dx: 0, dy: 20)
    let path = UIBezierPath(roundedRect: rect, cornerRadius: Constants.questionMaskRadius)

    let rd = Constants.questionRoundMaskRadius
    let circleRect: CGRect = CGRect(x: bounds.width/2-rd, y: 0.0, width: rd*2, height: rd*2)
    let circlePath = UIBezierPath(ovalIn: circleRect)
    path.append(circlePath)

    let layer = CAShapeLayer()
    layer.path = path.cgPath
    self.layer.mask = layer
  }

  private var is4Inch: Bool {
    return UIScreen.main.bounds.height == 568
  }
}
