//
//  BFWStoryboardReferenceSegue.h
//
//  Created by Tom Brodhurst-Hill on 30/09/2015.
//  Copyright (c) 2015 BareFeetWare. Free to use and modify, without warranty.
//
//  BFWStoryboardReferenceSegue emulates the functionality of XCode 7's storyboard references
//  but also supports for iOS 7.
//
//  To use it, follow a similar to an Xcode 7's storyboard reference:
//  1. Place a placeholder view controller in your storyboard and set its title
//     (or navigationItem.title) to the name of the desired storyboard.
//  2. Use a subclasses of BFWStoryboardReferenceSegue to segue to the storyboard reference.
//
//  Once iOS 7 is no longer supported by this app you can replace the placeholder view controllers
//  with Xcode 7's storyboard references. There is no need to change view controllers or other code.
//

#import <UIKit/UIKit.h>

@interface BFWStoryboardReferenceSegue : UIStoryboardSegue

@property (nonatomic, assign) BOOL animates; // For iOS 7 backwards compatibility.

@end
