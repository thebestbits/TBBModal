//
//  UIViewController+CustomTransition.h
//  Cloud Palettes
//
//  Created by derrick on 9/7/13.
//  Copyright (c) 2013 The Best Bits LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (TBBCustomTransition)
@property (nonatomic) id <UIViewControllerAnimatedTransitioning> tbb_customTransitioning;
@end
