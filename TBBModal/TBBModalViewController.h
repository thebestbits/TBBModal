//
//  TBBModalViewController.h
//  Modal
//
//  Created by derrick on 2/10/14.
//  Copyright (c) 2014 thebestbits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBBModalViewController : UITableViewController
@property (nonatomic, weak) UIView *snapshotView;
@property (nonatomic) UIImage *snapshot;
@property (nonatomic) UIImage *selectedSnapshot;
@end
