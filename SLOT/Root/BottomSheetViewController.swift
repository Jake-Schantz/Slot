//
//  BottomSheetViewController.swift
//  BottomSheet
//
//  Created by Ahmed Elassuty on 7/1/16.
//  Copyright © 2016 Ahmed Elassuty. All rights reserved.
//

import UIKit

class BottomSheetViewController: UIViewController {
    
    
    var titles: [String] = ["Time parked", "Cost Per Hour", "Total Cost"]
    var lotInfo: [String:String] = ["Time parked": "2.5 hrs", "Cost Per Hour": "$2.00/hr", "Total Cost": "$9.00"]
    
    
    let handle: UIImageView = UIImageView(image: #imageLiteral(resourceName: "car"))
    let lotLabel = UILabel()
    let timeLabel = UILabel()
    let perHourLabel = UILabel()
    let totalLabel = UILabel()

//    let dateFormatter = DateFormatter()
//    NSDateFormatter *dateFormat = [NSDateFormatter new];
//    [dateFormat setDateFormat: @"yyyy-MM-dd HH:mm:ss zzz"];
//
//    NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
//
//    NSLog(@"%@",dateString);
//    and the other way from formatted string to NSDate
//
//    NSDate *d = [NSDate new];
//
//    d = [dateFormat dateFromString:dateString];
//
//    NSLog(@"the date %@", d);
    

    var isOpen: Bool {
        get {
            return self.view.frame.minY == fullView
        }
    }
    var fullView: CGFloat {
        return UIScreen.main.bounds.height - 210
    }
    var partialView: CGFloat {
        return UIScreen.main.bounds.height - 49
    }
    
    
    func createHandle(){
        handle.frame = CGRect(x: view.center.x, y: view.frame.height, width: 35, height: 35)
        handle.center = CGPoint(x: view.center.x, y: 25)
        
        lotLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width*18/20, height: 35)
        lotLabel.center = CGPoint(x: self.view.frame.width/2, y: 25)
        lotLabel.textAlignment = .center
        lotLabel.font = UIFont(name: "Helvetica Neue", size: 24)
        lotLabel.textColor = Slot.blue
        lotLabel.text = "Current Lot"
        lotLabel.alpha = 0.0
        
        self.view.addSubview(self.lotLabel)
        self.view.addSubview(self.handle)
    }
    
    
    func lotInfoUi(inputView: UIView) {
        inputView.backgroundColor = Slot.blue
        inputView.layer.cornerRadius = 18
        inputView.layer.masksToBounds = true
        
        inputView.layer.shadowColor = UIColor.black.cgColor
        inputView.layer.shadowOpacity = 0.5
        inputView.layer.shadowOffset = CGSize(width: 2, height: 2)
        inputView.layer.shadowRadius = 3
    }
    
    func lotInfoLabels(inputLabel: UILabel){
        inputLabel.textAlignment = .center
        inputLabel.font = UIFont(name: "Helvetica Neue", size: 20)
        inputLabel.textColor = Slot.white
    }
    
    
    func createUI(){
        let quarterWidth = view.frame.width/4
        let height: CGFloat = 50
        let commonFrame = CGRect(x: 0, y: 0, width: view.frame.width*8/20, height: height)
        
        timeLabel.frame = commonFrame
        timeLabel.center = CGPoint(x: quarterWidth, y: 85)
        lotInfoUi(inputView: timeLabel)
        lotInfoLabels(inputLabel: timeLabel)
        timeLabel.text = lotInfo[titles[0]]
        
        perHourLabel.frame = commonFrame
        perHourLabel.center = CGPoint(x: quarterWidth*3, y: 85)
        lotInfoUi(inputView: perHourLabel)
        lotInfoLabels(inputLabel: perHourLabel)
        perHourLabel.text = lotInfo[titles[1]]
        
        let totalCostView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width*18/20, height: height))
        totalCostView.center = CGPoint(x: quarterWidth*2, y: 155)
        createGradientLayer(inputView: totalCostView)
        lotInfoUi(inputView: totalCostView)
        totalCostView.backgroundColor = Slot.lightBlue
        
        let titleLabel = UILabel(frame: commonFrame)
        titleLabel.center = CGPoint(x: quarterWidth, y: 155)
        lotInfoLabels(inputLabel: titleLabel)
        titleLabel.text = titles[2]
        
        totalLabel.frame = commonFrame
        totalLabel.center = CGPoint(x: quarterWidth*3, y: 155)
        lotInfoLabels(inputLabel: totalLabel)
        totalLabel.text = lotInfo[titles[2]]
        
        self.view.addSubview(timeLabel)
        self.view.addSubview(perHourLabel)
        self.view.addSubview(totalCostView)
        self.view.addSubview(titleLabel)
        self.view.addSubview(totalLabel)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(BottomSheetViewController.panGesture))
        view.addGestureRecognizer(gesture)
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tap)
        prepareBackgroundView()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createHandle()
        createUI()
        let frame = self.view.frame
        let yComponent = self.partialView
        self.view.frame = CGRect(x: 0, y: yComponent, width: frame.width, height: frame.height)
        self.view.layer.cornerRadius = 20
        self.view.layer.masksToBounds = true
    }
    
    func openClose() {
        UIView.animate(withDuration: 0.2, animations: {
            let frame = self.view.frame
            
            
            let placeHolder = self.handle.alpha
            self.handle.alpha = self.lotLabel.alpha
            self.lotLabel.alpha = placeHolder
            
            let y = self.isOpen ? self.partialView : self.fullView
            self.view.frame = CGRect(x: 0, y: y, width: frame.width, height: frame.height)
        })
    }
    
    
    
    
    @objc func viewTapped() {
        if !isOpen {
            openClose()
        }
    }
    
    
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        let y = self.view.frame.minY
        if ( y + translation.y >= fullView) && (y + translation.y <= partialView ) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended {
            var duration = velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                
                var size = self.fullView
                if velocity.y >= 0 {
                    self.handle.alpha = 1.0
                    self.lotLabel.alpha = 0.0
                    size = self.partialView
                } else {
                    self.handle.alpha = 0.0
                    self.lotLabel.alpha = 1.0
                }
                self.view.frame = CGRect(x: 0, y: size, width: self.view.frame.width, height: self.view.frame.height)
                
            }, completion: nil)
        }
    }
    
    
    func prepareBackgroundView(){
        let blurEffect = UIBlurEffect.init(style: .regular)
        let bluredView = UIVisualEffectView.init(effect: blurEffect)
        bluredView.frame = UIScreen.main.bounds
        view.insertSubview(bluredView, at: 0)
        view.layer.cornerRadius = 20
    }
}


extension BottomSheetViewController: RootDelegate {
    func didTapOnView() {
        if isOpen {
            openClose()
        }
    }
}
