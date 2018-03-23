//
//  Contants.swift
//  HQTriviaDemo
//
//  Created by Chingis Gomboev on 23/03/2018.
//  Copyright © 2018 Chingis Gomboev. All rights reserved.
//

import UIKit

enum Constants {
  static let animationDuration: TimeInterval = 0.2
  static let defaultAnchor = CGPoint(x: 0.5, y: 0.5)
  static let collapedAnchor = CGPoint(x: 0.53, y: 1.35)
  static let roundMaskY: CGFloat = 80
  static let roundMaskRadius: CGFloat = 50
  static let questionRoundMaskRadius: CGFloat = 60
  static let questionMaskRadius: CGFloat = 26
  static let collapsingTransform = CATransform3DMakeScale(0.34, 0.34, 1)
  static let questionTransform = CATransform3DMakeScale(0.7, 0.7, 1)
  static let buttonTransform = CATransform3DMakeScale(0.95, 0.95, 1)
  static let bgColor = UIColor(displayP3Red: 73.0/255, green: 161.0/255, blue: 248.0/255, alpha: 1.0)
  static let answerBtnBGColor = UIColor(displayP3Red: 132.0/255, green: 92.0/255, blue: 238.0/255, alpha: 1.0)

  static let questionInsets = UIEdgeInsets(top: 60, left: 20, bottom: 0, right: 20)
}
