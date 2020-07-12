//
//  TransitionAnimator.m
//  Airtickets
//
//  Created by Maksim Romanov on 05.07.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "TransitionAnimator.h"

@implementation TransitionAnimator

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [[transitionContext containerView] addSubview:toViewController.view];
    toViewController.view.alpha = 0;
    
    if (self.operation == UINavigationControllerOperationPush) {
        //NSLog(@"UINavigationControllerOperationPush");
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.transform = CGAffineTransformMakeScale(0.1, 0.1);
            toViewController.view.alpha = 1;
        } completion:^(BOOL finished) {
            fromViewController.view.transform = CGAffineTransformIdentity;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    } else if (self.operation == UINavigationControllerOperationPop) {
        //NSLog(@"UINavigationControllerOperationPop");
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.transform = CGAffineTransformMakeScale(10.0, 10.0);
            toViewController.view.alpha = 1;
        } completion:^(BOOL finished) {
            fromViewController.view.transform = CGAffineTransformIdentity;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
    /*
    switch (self.operation) {
        case UINavigationControllerOperationPush:
            NSLog(@"UINavigationControllerOperationPush");
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                fromViewController.view.transform = CGAffineTransformMakeScale(0.1, 0.1);
                toViewController.view.alpha = 1;
            } completion:^(BOOL finished) {
                fromViewController.view.transform = CGAffineTransformIdentity;
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }];
            break;
        case UINavigationControllerOperationPop:
            NSLog(@"UINavigationControllerOperationPop");
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                fromViewController.view.transform = CGAffineTransformMakeScale(10.0, 10.0);
                toViewController.view.alpha = 1;
            } completion:^(BOOL finished) {
                fromViewController.view.transform = CGAffineTransformIdentity;
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }];
        default:
            break;
    }*/
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.8;
}

@end
