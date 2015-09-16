//
//  GMUserModal.h
//  GrocerMax
//
//  Created by Deepak Soni on 16/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMUserModal : NSObject

@property (nonatomic, readonly, strong) NSString *firstName;

@property (nonatomic, readonly, strong) NSString *lastName;

@property (nonatomic, readonly, strong) NSString *mobile;

@property (nonatomic, readonly, strong) NSString *email;

@property (nonatomic, readonly, strong) NSString *password;

@property (nonatomic, readonly, assign) GMGenderType gender;

- (void)setFirstName:(NSString *)firstName;

- (void)setLastName:(NSString *)lastName;

- (void)setMobile:(NSString *)mobile;

- (void)setEmail:(NSString *)email;

- (void)setPassword:(NSString *)password;

- (void)setGender:(GMGenderType)gender;
@end
