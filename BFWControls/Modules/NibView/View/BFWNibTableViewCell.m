//
//  BFWNibTableViewCell.m
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 30/5/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//

#import "BFWNibTableViewCell.h"
#import <BFWControls/BFWControls-Swift.h>

@implementation BFWNibTableViewCell

#pragma mark - Init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        BFWNibTableViewCell *nibView = (BFWNibTableViewCell *)[super replacedByNibViewFromNibNamed:nil in:nil];
        if (nibView != self) {
            nibView.frame = super.frame;
            [nibView copySubviewPropertiesFrom: self];
            self = nibView;
            self.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5]; // testing
        }
    }
    return self;
}

@end
