//
//  BFWPushStoryboardSegue.m
//
//  Created by Tom Brodhurst-Hill on 28/08/2015.
//  Copyright (c) 2015 BareFeetWare. Free to use and modify, without warranty.
//

#import "BFWPushStoryboardSegue.h"

@implementation BFWPushStoryboardSegue

- (void)perform {
    UIViewController *viewController = self.destinationViewController;
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)viewController;
        viewController = navigationController.viewControllers.firstObject;
    }
    [self.sourceViewController.navigationController pushViewController:viewController
                                                              animated:YES];
}

@end
