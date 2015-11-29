//
//  MorphTableViewController.m
//
//  Created by Tom Brodhurst-Hill on 27/10/2015.
//  Copyright © 2015 BareFeetWare. Free to use and modify, without warranty.
//

#import "MorphTableViewController.h"
#import "BFWControls-Swift.h"

@interface MorphTableViewController ()

@end

@implementation MorphTableViewController


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue isKindOfClass:[BFWMorphStoryboardSegue class]]) {
        BFWMorphStoryboardSegue *morphSegue = (BFWMorphStoryboardSegue *)segue;
        if ([sender isKindOfClass:[UITableViewCell class]]) {
            UITableViewCell *cell = (UITableViewCell *)sender;
            morphSegue.fromView = cell;
        }
    }
}

@end
