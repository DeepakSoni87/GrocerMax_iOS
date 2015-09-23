//
//  GMSharedClass.h
//  GrocerMax
//
//  Created by Deepak Soni on 09/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GMUserModal;
@class GMCityModal;
@class UIViewController;

@interface GMSharedClass : NSObject

+ (instancetype)sharedClass;

- (void)showErrorMessage:(NSString*)message;

- (void)showWarningMessage:(NSString*)message;

- (void)showSuccessMessage:(NSString*)message;

- (void)showInfoMessage:(NSString*)message;

+ (BOOL)validateEmail:(NSString*)emailString;

+ (BOOL)validateMobileNumberWithString:(NSString*)mobile;

- (BOOL)getUserLoggedStatus;

- (void)setUserLoggedStatus:(BOOL)status;

- (void)setTabBarVisible:(BOOL)visible ForController:(UIViewController *)controller animated:(BOOL)animated;

- (void)saveLoggedInUserWithData:(NSData *)userData;

- (GMUserModal *)getLoggedInUser;

- (GMCityModal *)getSavedLocation;

- (void)saveSelectedLocationData:(NSData *)userData;


@end
