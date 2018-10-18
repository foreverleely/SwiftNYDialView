//
//  NYDialView.swift
//  SwiftNYDialView
//
//  Created by liyangly on 2018/10/18.
//  Copyright © 2018 liyang. All rights reserved.
//

import UIKit

class NYDialView: UIView {
    
    let colorList = [#colorLiteral(red: 1, green: 0.1372103425, blue: 0.130794345, alpha: 1), #colorLiteral(red: 1, green: 0.6652557574, blue: 0.147631881, alpha: 1), #colorLiteral(red: 0.9752265971, green: 1, blue: 0.1470222125, alpha: 1), #colorLiteral(red: 0.7333434987, green: 1, blue: 0.2298419807, alpha: 1), #colorLiteral(red: 0.2682292342, green: 1, blue: 0.2199875573, alpha: 1), #colorLiteral(red: 0.1151032753, green: 1, blue: 0.7232209064, alpha: 1), #colorLiteral(red: 0.1160938976, green: 1, blue: 0.9530499531, alpha: 1), #colorLiteral(red: 0.1245826077, green: 0.6376351167, blue: 1, alpha: 1), #colorLiteral(red: 0.1048812169, green: 0.2643207538, blue: 1, alpha: 1), #colorLiteral(red: 0.4997262692, green: 0.1649972863, blue: 1, alpha: 1), #colorLiteral(red: 0.9958228607, green: 0.1906148489, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.1426586242, blue: 0.6407351882, alpha: 1), #colorLiteral(red: 1, green: 0.6695049446, blue: 0.6495739266, alpha: 1)]
    let titleList = ["3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A", "2"]
    let btnWidth = 20
    let radius: CGFloat = 150
    /***********/
    var btnList = [UIButton]()
    var beginPoint = CGPoint()
    var movePoint = CGPoint()
    var runAngle: Double = 0
    var panAngle: Double = 0
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(circleViewGesture(_:)))
        self.addGestureRecognizer(pan)
        
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() {
        self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.layer.cornerRadius = radius
        self.layer.shadowPath = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: radius).cgPath
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 5
        
        configPieGraph()
        configButton()
    }
    
    func configPieGraph() {
        let center = CGPoint(x: radius, y: radius)
        var start: Double = 0
        var angle: Double = 0
        var end = -Double(1)/Double(colorList.count) * .pi
        
        for bgColor in colorList {
            start = end
            angle = Double(1)/Double(self.colorList.count) * .pi * 2
            end = start + angle
            
            let path = UIBezierPath.init(arcCenter: center, radius: radius, startAngle: CGFloat(start), endAngle: CGFloat(end), clockwise: true)
            path.addLine(to: center)
            
            let layer = CAShapeLayer()
            layer.fillColor = bgColor.cgColor
            layer.strokeColor = UIColor.white.cgColor
            layer.lineWidth = 0
            layer.path = path.cgPath
            layer.strokeEnd = 1.0
            
            let animation = CABasicAnimation.init(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.toValue = 1
            animation.duration = 0.1
            layer.add(animation, forKey: "strokeEnd")
            self.layer.addSublayer(layer)
        }
    }
    
    func configButton() {
        for btnTitle in titleList {
            let btn = UIButton(type: .custom)
            btn.setTitle(btnTitle, for: .normal)
            btn.setTitleColor(#colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1176470588, alpha: 1), for: .normal)
            btn.frame = CGRect(x: 0, y: 0, width: btnWidth, height: btnWidth)
            btn.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            btn.layer.cornerRadius = CGFloat(btnWidth/2)
            self.addSubview(btn)
            
            btnList.append(btn)
        }
        
        btnsLayout()
    }
    
    func btnsLayout() {
        var i = 0
        let num = btnList.count
        
        for btn in btnList {
            
            let yy = Double(radius) + sin(Double(i)/Double(num) * .pi * 2 + runAngle) * (Double(radius) - Double(btnWidth/2) - 20)
            let xx = Double(radius) + cos(Double(i)/Double(num) * .pi * 2 + runAngle) * (Double(radius) - Double(btnWidth/2) - 20)
            btn.center = CGPoint(x: xx, y: yy)
            
            i += 1
        }
    }
    
    // MARK: - Private Method
    
    func getSelectButton() {
        let num = btnList.count
        let start = -Double(1)/Double(num) * .pi / 2;
        let end = Double(1)/Double(num) * .pi / 2;
        
        // - x-axis
        for btn in btnList {
            let angle = getAngle(btn.center)
            let quadrant = getQuadrant(btn.center)
            
            if (quadrant == 2 || quadrant == 3) && angle > start && angle < end {
                print(btn.titleLabel?.text ?? "123")
            }
        }
    }
    
    func calculateRunAngle() {
        let num = btnList.count
        let value = .pi * 2 / Double(num)
        let va = fmod(runAngle, value)
        
        if runAngle >= 0 {
            if fabs(va) > (value/2) {
                runAngle -= fabs(va)
                runAngle += value/2
            } else {
                runAngle -= fabs(va)
            }
        } else {
            if fabs(va) > (value/2) {
                runAngle += fabs(va)
                runAngle -= value/2
            } else {
                runAngle += fabs(va)
            }
        }
    }
    
    func getAngle(_ point: CGPoint) -> Double {
        let x = point.x - radius
        let y = point.y - radius
        return Double(asin(y/hypot(x, y)))
    }
    
    func getQuadrant(_ point: CGPoint) -> Int {
        let x = point.x - radius
        let y = point.y - radius
        
        if x > 0 {
            return y > 0 ? 1 : 4
        } else {
            return y > 0 ? 2 : 3
        }
    }
    
    // MARK: - GestureRecognizer
    
    @objc func circleViewGesture(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == UIGestureRecognizer.State.began {
            beginPoint = gesture.location(in: self)
        } else if gesture.state == UIGestureRecognizer.State.changed {
            movePoint = gesture.location(in: self)
            let start = getAngle(beginPoint)
            let move = getAngle(movePoint)
            
            let isOneFourGuadrant = (getQuadrant(movePoint) == 1 || getQuadrant(movePoint) == 4)
            if isOneFourGuadrant {
                runAngle += move - start
            } else {
                runAngle += start - move
            }
            
            btnsLayout()
            movePoint = beginPoint
        } else if gesture.state == UIGestureRecognizer.State.ended {
            calculateRunAngle()
            self.isUserInteractionEnabled = false
            
            UIView.animate(withDuration: 0.4, animations: {
                self.btnsLayout()
                self.isUserInteractionEnabled = true
            }) { (isFinish) in
                self.getSelectButton()
            }
        }
    }
    
}
