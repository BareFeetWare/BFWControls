//
//  BFWStoryboardReferenceSegue.m
//
//  Created by Tom Brodhurst-Hill on 30/09/2015.
//  Copyright (c) 2015 BareFeetWare. Free to use and modify, without warranty.
//

#import "BFWStoryboardReferenceSegue.h"

@interface BFWStoryboardReferenceSegue ()

@property (nonatomic, strong) UIViewController *destinationViewController;

@end

@implementation BFWStoryboardReferenceSegue

@synthesize destinationViewController = _overrideDestinationViewController;

#pragma mark - init

- (instancetype)initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination {
    self = [super initWithIdentifier:identifier source:source destination:destination];
    if (self) {
        _animates = YES;
    }
    return self;
}

#pragma mark - accessors

- (UIViewController *)destinationViewController {
    if (!_overrideDestinationViewController) {
        _overrideDestinationViewController = super.destinationViewController;
        NSString *storyboardName = _overrideDestinationViewController.title ?: _overrideDestinationViewController.navigationItem.title;
        if (storyboardName.length) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName
                                                                 bundle:nil];
            _overrideDestinationViewController = [storyboard instantiateInitialViewController];
        }
    }
    return _overrideDestinationViewController;
}

#pragma mark - accessors only called on iOS7

// These methods must be implemented to prevent a crash in iOS7,
// since Xcode 7 calls them but they are not built into iOS 7.

- (void)setUseDefaultModalPresentationStyle:(BOOL)useStyle {
}

- (void)setUseDefaultModalTransitionStyle:(BOOL)useStyle {
    
}

- (void)setModalPresentationStyle:(UIModalPresentationStyle)style {
    self.destinationViewController.modalPresentationStyle = style;
}

- (void)setModalTransitionStyle:(UIModalTransitionStyle)style {
    self.destinationViewController.modalTransitionStyle = style;
}

#pragma mark - actions

- (void)perform {
    // Implement in subclass.
}

@end
