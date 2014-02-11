//
//  TBBModalViewController.m
//  Modal
//
//  Created by derrick on 2/10/14.
//  Copyright (c) 2014 thebestbits. All rights reserved.
//

#import "TBBModalViewController.h"
#import "UIViewController+TBBCustomTransition.h"
#import "TBBModalStyleAnimatedTransition.h"


@interface UITableViewCell (TBBModalCell)
- (void)updateCellWithSnapshotView:(UIView *)snapshotView snapshotImage:(UIImage *)snapshot selectedSnapshotImage:(UIImage *)selectedImage;
- (void)updateMaskIsTop:(BOOL)isTop isBottom:(BOOL)isBottom;
- (void)layoutBackgroundsToMirrorView:(UIView *)snapshotView;
@end


@interface TBBModalViewController () <UIViewControllerTransitioningDelegate>
@end


@implementation TBBModalViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;
        self.tbb_customTransitioning = [TBBModalStyleAnimatedTransition new];
    }
    return self;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)awakeFromNib
{
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self;
    self.tbb_customTransitioning = [TBBModalStyleAnimatedTransition new];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0f / [UIScreen mainScreen].scale;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @" ";
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    UIView *bg = [UIView new];
    bg.backgroundColor = [UIColor clearColor];
    header.backgroundView = bg;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell updateCellWithSnapshotView:self.snapshotView snapshotImage:self.snapshot selectedSnapshotImage:self.selectedSnapshot];
    
    [cell updateMaskIsTop:indexPath.section == 0 && indexPath.row == 0 isBottom:indexPath.section == tableView.numberOfSections - 1 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1];
}

- (void)updateCellBackgrounds
{
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        [cell layoutBackgroundsToMirrorView:self.snapshotView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateCellBackgrounds];
}

- (void)padTableView {
    UITableView *tableView = self.tableView;
    UIView *header = tableView.tableHeaderView;
    UIView *footer = tableView.tableFooterView;
    
    CGRect tableBounds = tableView.bounds;
    UIEdgeInsets insets = tableView.contentInset;
    CGFloat height = tableBounds.size.height - insets.top - insets.bottom;
    for (NSInteger section = 0; section < tableView.numberOfSections; ++section) {
        for (NSInteger row = 0; row < [tableView numberOfRowsInSection:section]; ++row) {
            height -= [tableView.delegate tableView:tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
            if (height < 88) break;
        }
        if (height < 88) break;
    }
    height = floorf(MAX(44, height/2.0));
    CGRect headerFooterFrame = CGRectMake(0, 0, tableBounds.size.width, height);
    
    if (header.frame.size.height != height) {
        tableView.tableHeaderView = header = [[UIView alloc] initWithFrame:headerFooterFrame];
        tableView.tableFooterView = footer = [[UIView alloc] initWithFrame:headerFooterFrame];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self padTableView];
    [self updateCellBackgrounds];
}


#pragma mark UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self.tbb_customTransitioning;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self.tbb_customTransitioning;
}

@end

@implementation UITableViewCell (TBBModalCell)

- (void)updateBackgroundWithSnapshot:(UIImage *)snapshot
{
    UIImageView *snapshotImageView = [self.backgroundView.subviews firstObject];
    if (snapshotImageView == nil) {
        snapshotImageView = [[UIImageView alloc] initWithImage:snapshot];
        snapshotImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        UIView *bg = [UIView new];
        bg.clipsToBounds = YES;
        self.backgroundView = bg;
        [self.backgroundView addSubview:snapshotImageView];
    }
    snapshotImageView.image = snapshot;
}

- (void)updateSelectedBackgroundWithSnapshot:(UIImage *)selectedSnapshot
{
    UIImageView * selectedSnapshotImageView = [self.selectedBackgroundView.subviews firstObject];
    if (selectedSnapshotImageView == nil) {
        selectedSnapshotImageView = [[UIImageView alloc] initWithImage:selectedSnapshot];
        selectedSnapshotImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        UIView *selected = [UIView new];
        selected.clipsToBounds = YES;
        self.selectedBackgroundView = selected;
        [self.selectedBackgroundView addSubview:selectedSnapshotImageView];
    }
    selectedSnapshotImageView.image = selectedSnapshot;
}

- (void)updateCellWithSnapshotView:(UIView *)snapshotView snapshotImage:(UIImage *)snapshot selectedSnapshotImage:(UIImage *)selectedImage
{
    [self updateBackgroundWithSnapshot:snapshot];
    [self updateSelectedBackgroundWithSnapshot:selectedImage];
    
    [self layoutBackgroundsToMirrorView:snapshotView];
}

- (void)layoutBackgroundsToMirrorView:(UIView *)snapshotView
{
    CGPoint origin = [snapshotView convertPoint:CGPointZero toView:self];
    
    UIImageView *snapshotImageView = [self.backgroundView.subviews firstObject];
    CGSize size = snapshotImageView.image.size;
    snapshotImageView.frame = (CGRect){ .origin = origin, .size = size };
    
    UIImageView *selectedSnapshotImageView = [self.selectedBackgroundView.subviews firstObject];
    selectedSnapshotImageView.frame = (CGRect){ .origin = origin, .size = size };
}

- (void)updateMaskIsTop:(BOOL)isTop isBottom:(BOOL)isBottom
{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    if (isTop && isBottom) {
        self.layer.mask = nil;
    } else {
        CAShapeLayer *mask = [CAShapeLayer layer];
        
        UIRectCorner corners = 0;
        if (isTop) {
            corners |= (UIRectCornerTopLeft | UIRectCornerTopRight);
        }
        if (isBottom) {
            corners |= (UIRectCornerBottomRight | UIRectCornerBottomLeft);
        }
        mask.fillColor = [UIColor blackColor].CGColor;
        mask.lineWidth = 0.f;
        mask.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(8.f, 8.f)].CGPath;
        self.layer.mask = mask;
    }
    [CATransaction commit];

}

@end
