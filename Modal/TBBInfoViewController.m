//
//  TBBInfoViewController.m
//  Modal
//
//  Created by derrick on 2/11/14.
//  Copyright (c) 2014 thebestbits. All rights reserved.
//

#import "TBBInfoViewController.h"

@implementation TBBInfoViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == tableView.numberOfSections - 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
