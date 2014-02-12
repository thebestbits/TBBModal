//
//  TBBModalStyleAnimatedTransition.m
//  Cloud Palettes
//
//  Created by derrick on 9/7/13.
//  Copyright (c) 2013 The Best Bits LLC. All rights reserved.
//

#import "TBBModalStyleAnimatedTransition.h"
#import "UIImage+TBBImageEffects.h"
#import "TBBModalViewController.h"

@interface TBBModalStyleAnimatedTransition ()
@property (nonatomic) UIView *shadow;
@property (nonatomic, getter = isPresenting) BOOL presenting;
@end

@implementation TBBModalStyleAnimatedTransition

- (id)init
{
    self = [super init];
    if (self) {
        self.presenting = YES;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3f;
}

- (void)presentInContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = transitionContext.containerView;
    
    UIViewController *source = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIGraphicsBeginImageContextWithOptions(source.view.bounds.size, YES, 0);
    [source.view drawViewHierarchyInRect:source.view.bounds afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *extraLightImage = [image tbb_applyExtraLightEffect];
    UIColor *tint = [source.view.tintColor colorWithAlphaComponent:0.3];
    UIImage *lightImage = [image tbb_applyBlurWithRadius:20 tintColor:tint saturationDeltaFactor:0.8 maskImage:nil];
    
    TBBModalViewController *controller = (TBBModalViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    NSAssert([controller isKindOfClass:[TBBModalViewController class]], @"Must be presenting a TBBModalViewController");
    controller.snapshotView = source.view;
    controller.snapshot = extraLightImage;
    controller.selectedSnapshot = lightImage;
    
    UITableView *settings = (UITableView *)controller.view;
    settings.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    self.shadow = [[UIView alloc] initWithFrame:containerView.bounds];
    self.shadow.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    self.shadow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [containerView addSubview:self.shadow];
    [containerView addSubview:settings];
    
    settings.alpha = 0;
    settings.backgroundColor = [UIColor clearColor];
    CGAffineTransform transformForCurrentOrientation = settings.transform;
    settings.transform = CGAffineTransformScale(transformForCurrentOrientation, 1.2, 1.2);
    CGPoint center = containerView.center;
    settings.bounds = CGRectMake(0, 0, 280, containerView.bounds.size.height);
    settings.center = center;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.shadow.backgroundColor = [UIColor colorWithWhite:0. alpha:0.3];
        settings.alpha = 1;
        settings.transform = transformForCurrentOrientation;
    } completion:^(BOOL finished) {
        self.presenting = NO;
        [transitionContext completeTransition:YES];
    }];
}

- (void)dismissInContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *dismissed = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *dismissedView = dismissed.view;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        dismissedView.transform = CGAffineTransformScale(dismissedView.transform,  0.75, 0.75);
        dismissedView.alpha = 0.0;
        self.shadow.alpha = 0.0;
    } completion:^(BOOL finished) {
        [dismissedView removeFromSuperview];
        [self.shadow removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (self.presenting) {
        [self presentInContext:transitionContext];
    } else {
        [self dismissInContext:transitionContext];
    }
}

@end
