//
//  ZVRefreshDIYHeader.swift
//  Example
//
//  Created by zevwings on 2017/7/17.
//  Copyright © 2017年 zevwings. All rights reserved.
//

import UIKit
import ZVRefreshing

class ZVRefreshDIYHeader: ZVRefreshStateHeader {
    
    fileprivate lazy var _arrowView: UIImageView = {
        let arrowView = UIImageView()
        arrowView.image = UIImage(named: "arrow.png")
        return arrowView
    }()
    
    fileprivate lazy var _activityIndicator: UIActivityIndicatorView = {
        var activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = self.activityIndicatorViewStyle
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    public var activityIndicatorViewStyle: UIActivityIndicatorViewStyle = .gray {
        didSet {
            self._activityIndicator.activityIndicatorViewStyle = self.activityIndicatorViewStyle
            self.setNeedsLayout()
        }
    }
    
    override var state: State {
        get {
            return super.state
        }
        set {
            if self.checkState(newValue).result { return }
            super.state = newValue
            
            if newValue == .idle {
                if self.state == .refreshing {
                    self._arrowView.transform = CGAffineTransform.identity
                    UIView.animate(withDuration: 0.15, animations: {
                        self._activityIndicator.alpha = 0.0
                    }, completion: { _ in
                        guard self.state == .idle else { return }
                        self._activityIndicator.alpha = 1.0
                        self._activityIndicator.stopAnimating()
                        self._arrowView.isHidden = false
                    })
                } else {
                    self._activityIndicator.stopAnimating()
                    self._arrowView.isHidden = false
                    UIView.animate(withDuration: 0.15, animations: {
                        self._arrowView.transform = CGAffineTransform.identity
                    })
                }
            } else if newValue == .pulling {
                self._activityIndicator.stopAnimating()
                self._arrowView.isHidden = false
                UIView.animate(withDuration: 0.15, animations: {
                    self._arrowView.transform = CGAffineTransform(rotationAngle: 0.000001 - CGFloat(Double.pi))
                })
            } else if newValue == .refreshing {
                self._activityIndicator.alpha = 1.0
                self._activityIndicator.startAnimating()
                self._arrowView.isHidden = true
            }
        }
    }
}

extension ZVRefreshDIYHeader {
    
    override func prepare() {
        super.prepare()
        
        if self._arrowView.superview == nil {
            self.addSubview(self._arrowView)
        }
        
        if self._activityIndicator.superview == nil {
            self.addSubview(self._activityIndicator)
        }
    }
    
    override func placeSubViews() {
        super.placeSubViews()
        
        var centerX = self.frame.width * 0.5
        if !self.stateLabel.isHidden {
            centerX -= 100
        }
        let centerY = self.frame.height * 0.5
        let center = CGPoint(x: centerX, y: centerY)
        
        if self._arrowView.constraints.count == 0 && self._arrowView.image != nil {
            self._arrowView.isHidden = false
            self._arrowView.frame.size = self._arrowView.image!.size
            self._arrowView.center = center
        } else {
            self._arrowView.isHidden = true
        }
        
        if self._activityIndicator.constraints.count == 0 {
            self._activityIndicator.center = center
        }
    }
}
