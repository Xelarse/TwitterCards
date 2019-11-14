//
//  NavigationTransitionSource.swift
//  TwitterCards
//
//  Created by Alex Allman on 14/11/2019.
//  Copyright © 2019 Alex Allman. All rights reserved.
//

import Transition

class NavigationTransition {
    let transitionController: TransitionController
    let transitionsSource = NavigationTranstionSource()
    
    init(navigationController: UINavigationController) {
        transitionController = TransitionController(forTransitionsIn: navigationController, transitionsSource: transitionsSource)
    }
}

// • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • //

class NavigationTranstionSource : TransitionsSource {
    func transitionFor(operationContext: TransitionOperationContext, interactionController: TransitionInteractionController?) -> Transition {
        return Transition(duration: 0.5, animation: RightsidePushPop())
    }
}
