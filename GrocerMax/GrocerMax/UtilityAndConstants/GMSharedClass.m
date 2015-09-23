//
//  GMSharedClass.m
//  GrocerMax
//
//  Created by Deepak Soni on 09/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMSharedClass.h"
#import "GMUserModal.h"
#import "GMStateBaseModal.h"


#define kAlertTitle @"GrocerMax"

@implementation GMSharedClass

static GMSharedClass *sharedHandler;

static NSString *const loggedInUserKey = @"com.GrocerMax.loggedInUserKey";
static NSString *const signedInUserKey = @"com.GroxcerMax.signedInUserKey";
static NSString *const userSelectedUserLocationKey = @"com.GroxcerMax.selectedUserLocation";

CGFloat const kMATabBarHeight = 49.0f;

#pragma mark - SharedInstance Method

+ (instancetype)sharedClass {
    
    if(!sharedHandler) {
        sharedHandler  = [[[self class] alloc] init];
    }
    return sharedHandler;
}

#pragma mark - Error And Alert Messages

- (void) showErrorMessage:(NSString*)message{
    
    NSError *strongError = [RZErrorMessenger errorWithDisplayTitle:kAlertTitle detail:message error:nil];
    [RZErrorMessenger displayError:strongError withStrength:kRZMessageStrengthStrongAutoDismiss level:kRZErrorMessengerLevelError animated:YES];
}

- (void) showSuccessMessage:(NSString*)message{
    
    NSError *strongError = [RZErrorMessenger errorWithDisplayTitle:kAlertTitle detail:message error:nil];
    [RZErrorMessenger displayError:strongError withStrength:kRZMessageStrengthStrongAutoDismiss level:kRZErrorMessengerLevelPositive animated:YES];
}

- (void) showWarningMessage:(NSString*)message{
    
    NSError *strongError = [RZErrorMessenger errorWithDisplayTitle:kAlertTitle detail:message error:nil];
    [RZErrorMessenger displayError:strongError withStrength:kRZMessageStrengthStrongAutoDismiss level:kRZErrorMessengerLevelWarning animated:YES];
}

- (void) showInfoMessage:(NSString*)message{
    
    NSError *strongError = [RZErrorMessenger errorWithDisplayTitle:kAlertTitle detail:message error:nil];
    [RZErrorMessenger displayError:strongError withStrength:kRZMessageStrengthStrongAutoDismiss level:kRZErrorMessengerLevelInfo animated:YES];
}

+ (BOOL)validateEmail:(NSString*)emailString {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValid = [emailTest evaluateWithObject:emailString];
    return isValid;
}

+ (BOOL)validateMobileNumberWithString:(NSString*)mobile {
    
    if (!NSSTRING_HAS_DATA(mobile))
        return NO;
    
    NSString *phoneRegex = @"^[789]\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    BOOL isValid = [phoneTest evaluateWithObject:mobile];
    return isValid;
}

- (BOOL)getUserLoggedStatus {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [[defaults objectForKey:loggedInUserKey] boolValue];
}

- (void)setUserLoggedStatus:(BOOL)status {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(status) forKey:loggedInUserKey];
    [defaults synchronize];
}

#pragma mark- UITabBar Animation

- (BOOL)tabBarIsVisible:(UIViewController*)controller {
    
    return controller.tabBarController.tabBar.frame.origin.y < SCREEN_SIZE.height;
}

- (void)setTabBarVisible:(BOOL)visible ForController:(UIViewController *)controller animated:(BOOL)animated {
    
    if ([self tabBarIsVisible:controller] == visible) return;
    
    CGRect frame = controller.tabBarController.tabBar.frame;
    CGFloat offsetY = (visible)? -kMATabBarHeight : kMATabBarHeight;
    
    CGFloat duration = (animated)? 0.3 : 0.0;
    
    [UIView animateWithDuration:duration animations:^{
        controller.tabBarController.tabBar.frame = CGRectOffset(frame, 0, offsetY);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)saveLoggedInUserWithData:(NSData *)userData {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userData forKey:signedInUserKey];
    [defaults synchronize];
}

- (GMUserModal *)getLoggedInUser {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:signedInUserKey];
    GMUserModal *archivedUser = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return archivedUser;
}

- (GMCityModal *)getSavedLocation {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:userSelectedUserLocationKey];
    GMCityModal *archivedUser = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return archivedUser;
}

- (void)saveSelectedLocationData:(NSData *)userData {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userData forKey:userSelectedUserLocationKey];
    [defaults synchronize];
}


@end
