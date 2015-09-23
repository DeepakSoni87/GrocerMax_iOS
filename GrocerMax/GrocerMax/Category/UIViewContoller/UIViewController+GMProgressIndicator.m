//
//  UIViewController+GMProgressIndicator.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 10/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "UIViewController+GMProgressIndicator.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "AppDelegate.h"

@implementation UIViewController (GMProgressIndicator)

- (void)showProgress {
    [self showProgressWithText:nil];
}

- (void)showProgressWithText:(NSString *)message {
    
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    [SVProgressHUD setForegroundColor:[UIColor inputTextFieldWarningColor]];
    //    [SVProgressHUD setRingThickness:1.0f];
    [SVProgressHUD setFont:FONT_REGULAR(13)];
    [SVProgressHUD showWithStatus:message maskType:SVProgressHUDMaskTypeClear];
}

- (void)removeProgress {
    [SVProgressHUD dismiss];
}

- (void)addLeftMenuButton {
    
    UIImage *image = [[UIImage imageNamed:@"menuBtn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if (self.navigationItem.leftBarButtonItem == nil){
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                                  initWithImage:image
                                                  style:UIBarButtonItemStylePlain
                                                  target:self
                                                  action:@selector(menuButtonPressed:)];
    }
}

- (void)menuButtonPressed:(UIBarButtonItem*)button {
    
    [self.view endEditing:YES];
    NSLog(@"menuButtonPressed");
//    [self.drawerController toggleDrawerSide:XHDrawerSideLeft animated:YES completion:nil];
    AppDelegate *appdel = APP_DELEGATE;
    [appdel.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

@end
