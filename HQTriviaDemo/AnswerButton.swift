//
//  AnswerButton.swift
//  HQTriviaDemo
//
//  Created by Chingis Gomboev on 23/03/2018.
//  Copyright © 2018 Chingis Gomboev. All rights reserved.
//

import UIKit

class AnswerButton: UIButton {
  let bgView = UIView()

  override func awakeFromNib() {
    super.awakeFromNib()
    layer.borderWidth = 1
    layer.borderColor = UIColor.lightGray.cgColor
    clipsToBounds = true

    bgView.alpha = 0
    bgView.backgroundColor = Constants.answerBtnBGColor
    insertSubview(bgView, at: 0)

    self.addTarget(self, action: #selector(AnswerButton.buttonTouchedDown(_:)), for: .touchDown)
    self.addTarget(self, action: #selector(AnswerButton.buttonTouchedUpInside(_:)), for: .touchUpInside)
    self.addTarget(self, action: #selector(AnswerButton.buttonTouchedUpOutside(_:)), for: .touchUpOutside)
    self.addTarget(self, action: #selector(AnswerButton.buttonTouchedUpOutside(_:)), for: .touchCancel)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = self.frame.height/2
    bgView.frame = bounds
  }

  @objc
  func buttonTouchedDown(_ sender: Any?) {
    UIView.animate(withDuration: 0.2, animations: {
      self.layer.transform = Constants.buttonTransform
      self.bgView.alpha = 0
    })
  }

  @objc
  func buttonTouchedUpInside(_ sender: Any?) {
    UIView.animate(withDuration: 0.2, animations: {
      self.layer.transform = CATransform3DIdentity
      self.bgView.alpha = 1
      self.setTitleColor(UIColor.white, for: .normal)
    })
    hideBG()
  }

  @objc
  func buttonTouchedUpOutside(_ sender: Any?) {
    UIView.animate(withDuration: 0.2, animations: {
      self.layer.transform = CATransform3DIdentity
      self.bgView.alpha = 0
    })
    hideBG()
  }

  private func hideBG() {
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(600)) {
      self.layer.transform = CATransform3DIdentity
      self.bgView.alpha = 0
      self.setTitleColor(UIColor.black, for: .normal)
    }
  }
}
