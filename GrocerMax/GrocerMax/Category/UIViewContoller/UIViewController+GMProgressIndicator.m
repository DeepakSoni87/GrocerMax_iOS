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
#import "GMSearchBarView.h"

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

#pragma mark - Add 3 Bar Menu Btn on Left Nav Bar

- (void)addLeftMenuButton {
    
    UIImage *image = [[UIImage menuBtnImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if (self.navigationItem.leftBarButtonItem == nil){
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                                  initWithImage:image
                                                  style:UIBarButtonItemStylePlain
                                                  target:self
                                                  action:@selector(menuButtonPressed:)];
    }
}

#pragma mark - Add Title View as logo image

- (void)addLogImageInNavBar {
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage logoImage]];
    imgView.frame = CGRectMake(0, 0, 1.64 * 40, 40);
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = imgView;
}

-(void)showSearchIconOnRightNavBarWithNavTitle:(NSString*)titleStr {
    
    self.navigationItem.titleView = nil;
    self.navigationItem.title = titleStr;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithImage:[UIImage searchIconImage]
                                              style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(searchButtonPressed:)];
}

-(void)showSearchIconOnRightNavBarWithNavImage:(UIImage*)navImage {
    
    if (navImage == nil) {
        [self addLogImageInNavBar];
    }else{
        UIImageView *imgView = [[UIImageView alloc] initWithImage:navImage];
        imgView.frame = CGRectMake(0, 0, 1.64 * 40, 40);
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        self.navigationItem.titleView = imgView;
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithImage:[UIImage searchIconImage]
                                              style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(searchButtonPressed:)];
}

-(void)searchButtonPressed:(UIBarButtonItem*)sender {
    
    self.navigationItem.rightBarButtonItem = nil;
    
    GMSearchBarView *searchBarview = [GMSearchBarView searchBarObj];
    searchBarview.delegate = self;

    self.navigationItem.titleView = searchBarview;
}

#pragma mark - menu btn Action

- (void)menuButtonPressed:(UIBarButtonItem*)button {
    
    [self.view endEditing:YES];
    AppDelegate *appdel = APP_DELEGATE;
    [appdel.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

@end
