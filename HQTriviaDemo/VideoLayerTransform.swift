//
//  VideoLayerTransform.swift
//  HQTriviaDemo
//
//  Created by Chingis Gomboev on 23/03/2018.
//  Copyright © 2018 Chingis Gomboev. All rights reserved.
//

import UIKit
import AVFoundation

public class VideoLayerTransform {

  let duration: TimeInterval = Constants.animationDuration

  private let layer: AVPlayerLayer
  private let view: UIView

  public init(layer: AVPlayerLayer, view: UIView) {
    self.layer = layer
    self.view = view
  }

  public func collapseAndRound() {
    collapseView()
    roundVideo()
  }

  public func cancel() {
    let maskLayer = view.layer.mask as! CAShapeLayer
    let maskLayer2 = fullMaskLayer
    startAnimation(from: maskLayer, to: maskLayer2)

    layer.anchorPoint = Constants.defaultAnchor
    layer.transform = CATransform3DIdentity
  }

  private var fullMaskLayer: CAShapeLayer {
    let c = CGPoint(x: view.bounds.width/2, y: view.bounds.height/2)
    let radius = sqrt(pow(c.x, 2) + pow(c.y, 2))

    return createMaskLayer(for: c, radius: radius)
  }

  private func roundVideo() {
    let maskLayer = fullMaskLayer
    view.layer.mask = maskLayer

    let p = CGPoint(x: view.bounds.width/2, y: Constants.roundMaskY)
    let maskLayer2 = createMaskLayer(for: p, radius: Constants.roundMaskRadius)

    startAnimation(from: maskLayer, to: maskLayer2)
  }

  private func collapseView() {
    UIView.animate(withDuration: duration, animations: {
      self.layer.anchorPoint = Constants.collapedAnchor
      self.layer.transform = Constants.collapsingTransform
    })
  }

  private func startAnimation(from maskLayer: CAShapeLayer, to maskLayer2: CAShapeLayer) {

    let anim = CABasicAnimation(keyPath: "path")
    anim.fromValue = maskLayer.path
    anim.toValue = maskLayer2.path
    anim.duration = duration
    anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    maskLayer.add(anim, forKey: nil)

    CATransaction.begin()
//    CATransaction.setDisableActions(true)
    CATransaction.setAnimationDuration(duration)
    maskLayer.path = maskLayer2.path
    CATransaction.commit()

  }

  private func createMaskLayer(for center: CGPoint, radius: CGFloat) -> CAShapeLayer {
    let bounds = CGRect(x: center.x-radius, y: center.y-radius, width: radius*2, height: radius*2)
    let path = UIBezierPath(roundedRect: bounds, cornerRadius: radius)
    let fillLayer = CAShapeLayer()
    fillLayer.path = path.cgPath
    fillLayer.fillRule = kCAFillRuleEvenOdd
    fillLayer.fillColor = UIColor.blue.cgColor
    fillLayer.opacity = 1.0
    return fillLayer
  }

}
