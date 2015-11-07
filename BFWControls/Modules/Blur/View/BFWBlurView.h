//
//  BFWBlurView.h
//
//  Created by Tom Brodhurst-Hill on 13/10/2015.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE // So it can draw a clear background.

@interface BFWBlurView : UIView

@property (nonatomic, assign) IBInspectable CGFloat blurRadius;

@end
