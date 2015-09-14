//
//  UIViewController+GMProgressIndicator.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 10/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "UIViewController+GMProgressIndicator.h"
#import <SVProgressHUD/SVProgressHUD.h>

@implementation UIViewController (GMProgressIndicator)

- (void)showProgress {
    [self showProgressWithText:nil];
}

- (void)showProgressWithText:(NSString *)message {
    
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRGBValue:89 green:43 blue:89]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    //    [SVProgressHUD setRingThickness:1.0f];
    [SVProgressHUD setFont:FONT_REGULAR(13)];
    [SVProgressHUD showWithStatus:message maskType:SVProgressHUDMaskTypeClear];
}

- (void)removeProgress {
    [SVProgressHUD dismiss];
}


@end
