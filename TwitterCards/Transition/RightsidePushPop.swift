//
//  RightsidePushPop.swift
//  TwitterCards
//
//  Created by Alex Allman on 14/11/2019.
//  Copyright © 2019 Alex Allman. All rights reserved.
//

import Transition

class RightsidePushPop : TransitionAnimation {
    
    private weak var topView: UIView?
    private var targetTransform: CGAffineTransform = .identity
    
    func setup(in operationContext: TransitionOperationContext) {
        let context = operationContext.context
        let isPresenting = operationContext.operation.isPresenting
        
        //  We have to add the toView to the transitionContext, at the appropriate index:
        if isPresenting {
            context.containerView.addSubview(context.toView)
        } else if context.toView.superview == nil {
            context.containerView.insertSubview(context.toView, belowSubview: context.fromView)
        }
        context.toView.frame = context.finalFrame(for: context.toViewController)
        
        //  We only animate the view that will be on top:
        topView = isPresenting ? context.toView : context.fromView
        
        let hiddenTransform = CGAffineTransform(translationX: context.containerView.bounds.width, y: 0)
        
        topView?.transform = isPresenting ? hiddenTransform : .identity
        targetTransform = isPresenting ? .identity : hiddenTransform
    }
    
    var layers: [AnimationLayer] {
        return [AnimationLayer(timingParameters: AnimationTimingParameters(animationCurve: .easeOut), animation: animate)]
    }
    
    func animate() {
        topView?.transform = targetTransform
    }
    
    func completion(position: UIViewAnimatingPosition) {}
}
