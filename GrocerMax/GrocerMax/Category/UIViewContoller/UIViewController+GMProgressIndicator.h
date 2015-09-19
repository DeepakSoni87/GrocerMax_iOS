//
//  UIViewController+GMProgressIndicator.h
//  GrocerMax
//
//  Created by Rahul Chaudhary on 10/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (GMProgressIndicator)

- (void)showProgress;
- (void)showProgressWithText:(NSString *)message;
- (void)removeProgress;

- (void)addLeftMenuButton;
- (void)menuButtonPressed:(UIBarButtonItem*)button;
@end
