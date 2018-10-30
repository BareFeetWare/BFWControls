//
//  BFWNibCollectionViewCell.m
//  BFWControls
//
//  Created by Andy Kim on 23/7/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//

#import "BFWNibCollectionViewCell.h"
#import <BFWControls/BFWControls-Swift.h>

@implementation BFWNibCollectionViewCell

// Init in Objective C so it can return a replacement for self.
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return [(NibCollectionViewCell *)self replacedByNibViewForInit];
}

@end
