//
//  GMSharedClass.h
//  GrocerMax
//
//  Created by Deepak Soni on 09/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMSharedClass : NSObject

+ (instancetype)sharedClass;

- (void) showErrorMessage:(NSString*)message;

- (void) showWarningMessage:(NSString*)message;

- (void) showSuccessMessage:(NSString*)message;

- (void) showInfoMessage:(NSString*)message;

+ (BOOL)validateEmail:(NSString*)emailString;

+ (BOOL)validateMobileNumberWithString:(NSString*)mobile;
@end
