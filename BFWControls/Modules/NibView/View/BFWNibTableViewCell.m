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

// Init in Objective C so it can return a replacement for self.
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return [(NibTableViewCell *)self replacedByNibViewForInit];
}

@end
