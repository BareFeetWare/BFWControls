//
//  BFWModalStoryboardSegue.m
//
//  Created by Tom Brodhurst-Hill on 28/08/2015.
//  Copyright (c) 2015 BareFeetWare. Free to use and modify, without warranty.
//

#import "BFWModalStoryboardSegue.h"

@implementation BFWModalStoryboardSegue

- (void)perform {
    [self.sourceViewController presentViewController:self.destinationViewController
                                            animated:self.animates
                                          completion:nil];
}

@end
