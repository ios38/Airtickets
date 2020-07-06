//
//  TransitionAnimator.h
//  Airtickets
//
//  Created by Maksim Romanov on 05.07.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface TransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (assign,nonatomic) UINavigationControllerOperation operation;

@end

NS_ASSUME_NONNULL_END
