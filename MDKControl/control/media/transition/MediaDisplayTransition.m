/**
 * Copyright (C) 2010 Sopra (support_movalys@sopra.com)
 *
 * This file is part of Movalys MDK.
 * Movalys MDK is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * Movalys MDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * You should have received a copy of the GNU Lesser General Public License
 * along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.
 */


#import "MediaDisplayTransition.h"


@implementation MediaDisplayTransition

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.appearing ? 0.45f : 0.45f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    //  Initialize context
    // --------------------
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //  Presenting
    // ------------
    if (self.appearing) {
        [transitionContext.containerView addSubview:toViewController.view];
        
        // Prepare transition animation
        CGRect viewFrame                = toViewController.view.frame;
        toViewController.view.alpha     = 0.0f;
        toViewController.view.center    = self.centerSource;
        toViewController.view.transform = CGAffineTransformMakeScale(self.frameSource.size.width/viewFrame.size.width, self.frameSource.size.height/viewFrame.size.height);
        
        // Perform transition animation
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        CGPoint viewCenter  = CGPointMake(screenBounds.size.width/2, screenBounds.size.height/2);
        
        // Animation
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.78f initialSpringVelocity:0.5f options:UIViewAnimationOptionCurveEaseInOut animations: ^{
            toViewController.view.transform = CGAffineTransformMakeScale(1, 1);
            toViewController.view.center    = viewCenter;
            toViewController.view.alpha     = 1.0f;
            toViewController.view.frame     = screenBounds;
        } completion: ^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    
    
    
    //  Dismissing
    // ------------
    else {
        [transitionContext.containerView addSubview:toViewController.view];
        [transitionContext.containerView addSubview:fromViewController.view];
        
        // Perform transition animation
        CGRect viewFrame = fromViewController.view.frame;
        
        // Animation
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.78f initialSpringVelocity:0.5f options:UIViewAnimationOptionCurveEaseInOut animations:^() {
            fromViewController.view.center      = self.centerSource;
            fromViewController.view.transform   = CGAffineTransformMakeScale(self.frameSource.size.width/viewFrame.size.width, self.frameSource.size.height/viewFrame.size.height);
            fromViewController.view.alpha       = 0.0f;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

@end
