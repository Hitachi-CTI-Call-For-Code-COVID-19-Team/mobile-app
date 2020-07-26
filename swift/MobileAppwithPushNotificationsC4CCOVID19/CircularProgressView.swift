//
//  CircularProgressView.swift
//  MobileAppwithPushNotificationsC4CCOVID19
//
//  Created by Watanabe Kentaro on 2020/07/23.
//  Copyright © 2020 IBM. All rights reserved.
//

import UIKit

class CircularProgressView: UIView {

    fileprivate var progressLayer = CAShapeLayer()
    fileprivate var trackLayer = CAShapeLayer()
    fileprivate var textLayer = CATextLayer()
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularPath()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createCircularPath()
    }
    
    var progressColor = UIColor.white {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }
    
    var trackColor = UIColor.white {
        didSet {
            trackLayer.strokeColor = trackColor.cgColor
        }
    }
    
    fileprivate func createCircularPath() {
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = self.frame.size.width/2
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height/2), radius: (frame.size.width), startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)
        trackLayer.path = circlePath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.lineWidth = 8.0
        trackLayer.strokeEnd = 1.0
        layer.addSublayer(trackLayer)
        
        progressLayer.path = circlePath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineWidth = 8.0
        progressLayer.strokeEnd = 0.0
        progressLayer.lineCap = CAShapeLayerLineCap.round
        layer.addSublayer(progressLayer)
        
        textLayer.font = UIFont(name: "HelveticaNeue-Light", size: 30)
        textLayer.frame = CGRect(x: 0, y: 0, width:frame.size.width * 2, height: frame.size.height)
        textLayer.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2 )
        textLayer.string = String(0)
        textLayer.foregroundColor = UIColor.systemTeal.cgColor
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.fontSize = 80
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
        //textLayer.isHidden = false
        layer.addSublayer(textLayer)
        
        
    }
    
    func setProgressWithAnimation(duration: TimeInterval, value: Float) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = value
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        progressLayer.strokeEnd = CGFloat(value)
        progressLayer.add(animation, forKey: "animateprogress")
        
    }
    
    func setTextWithAnimation(duration: TimeInterval, value: Float) {
        let animation = CABasicAnimation(keyPath: "string")
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = value
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        textLayer.string = String(Int(value))
        progressLayer.add(animation, forKey: "animateprogress")
        
    }

}
