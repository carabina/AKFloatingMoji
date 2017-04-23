//
//  AKFloatingMojiVC.swift
//  AKFloatingMoji
//
//  Created by MAC-186 on 7/7/16.
//  Copyright © 2016 Kode. All rights reserved.
//

import UIKit

class AKFloatingMojiVC : UIViewController, AKFloatingMojiDelegate  {

    @IBOutlet var lblMoji: UILabel!
    fileprivate let floatingMojiButton = AKFloatingMojiButton(title: "😍", pulses: true)
    fileprivate var previewInteraction: UIPreviewInteraction!
    fileprivate var floatingMojiController = AKFloatingMojiViewController()
    fileprivate var floatingMojiControllerIsPresented: Bool {
        return presentedViewController != nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        previewInteraction = UIPreviewInteraction(view: view)
        previewInteraction.delegate = self
        
        floatingMojiButton.action = {[unowned self] _ in
            if !self.floatingMojiControllerIsPresented {
                let sourcePoint = self.floatingMojiButton.center
                self.floatingMojiController = AKFloatingMojiViewController()
                self.floatingMojiController.delegate = self
                self.floatingMojiController.normalizedSourcePoint = normalizedPoint(sourcePoint, in: self.view)
                self.floatingMojiController.presentationIsInteractive = false
                self.present(self.floatingMojiController, animated: true)
            }
        }
        
        floatingMojiButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(floatingMojiButton)
        
        let constraints = [floatingMojiButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                           floatingMojiButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)]
        NSLayoutConstraint.activate(constraints)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    func send(reply: String) {
        lblMoji.text = reply
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension AKFloatingMojiVC: UIPreviewInteractionDelegate {
    func previewInteractionShouldBegin(_ previewInteraction: UIPreviewInteraction) -> Bool {
        return !floatingMojiControllerIsPresented
    }
    
    func previewInteraction(_ previewInteraction: UIPreviewInteraction, didUpdatePreviewTransition transitionProgress: CGFloat, ended: Bool) {
        if !floatingMojiControllerIsPresented {
            var sourcePoint = previewInteraction.location(in: view)
            if floatingMojiButton.frame.contains(sourcePoint) {
                sourcePoint = floatingMojiButton.center
            }
            floatingMojiController.normalizedSourcePoint = normalizedPoint(sourcePoint, in: view)
            floatingMojiController.presentationIsInteractive = true
            present(floatingMojiController, animated: true)
        }
        
        floatingMojiController.interactiveTransitionProgress = transitionProgress
        
        if ended {
            floatingMojiController.completeCurrentInteractiveTransition()
        }
    }
    
    func previewInteraction(_ previewInteraction: UIPreviewInteraction, didUpdateCommitTransition transitionProgress: CGFloat, ended: Bool) {
        floatingMojiController.previewTouchPosition = previewInteraction.location(in: floatingMojiController.view)
        floatingMojiController.overexpansion = transitionProgress
        
        if ended {
            floatingMojiController.previewTouchPosition = nil
            
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [.allowUserInteraction], animations: {
                self.floatingMojiController.overexpansion = 0.0
            })
        }
    }
    
    func previewInteractionDidCancel(_ previewInteraction: UIPreviewInteraction) {
        floatingMojiController.chooseTouchedReplyButton()
        floatingMojiController.cancelCurrentInteractiveTransition()
        floatingMojiController.dismiss(animated: true)
    }
}

private func normalizedPoint(_ point: CGPoint, in view: UIView) -> CGPoint {
    guard view.bounds.width > 0.0 && view.bounds.height > 0.0 else { return CGPoint.zero }
    let x = point.x / view.bounds.width
    let y = point.y / view.bounds.height
    return CGPoint(x: x, y: y)
}
