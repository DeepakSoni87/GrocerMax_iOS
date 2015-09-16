//
//  GMSharedClass.m
//  GrocerMax
//
//  Created by Deepak Soni on 09/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMSharedClass.h"


#define kAlertTitle @"GrocerMax"

@implementation GMSharedClass

static GMSharedClass *sharedHandler;

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
@end
