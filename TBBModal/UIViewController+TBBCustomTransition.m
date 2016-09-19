//
//  UIViewController+CustomTransition.m
//  Cloud Palettes
//
//  Created by derrick on 9/7/13.
//  Copyright (c) 2013 The Best Bits LLC. All rights reserved.
//

#import "UIViewController+TBBCustomTransition.h"
#import <objc/runtime.h>

@implementation UIViewController (TBBCustomTransition)

- (id<UIViewControllerAnimatedTransitioning>)tbb_customTransitioning
{
  return objc_getAssociatedObject(self, @selector(tbb_customTransitioning));
}

- (void)setTbb_customTransitioning:(id<UIViewControllerAnimatedTransitioning>)customTransitioning
{
  objc_setAssociatedObject(self, @selector(tbb_customTransitioning), customTransitioning, OBJC_ASSOCIATION_RETAIN);
}
@end
